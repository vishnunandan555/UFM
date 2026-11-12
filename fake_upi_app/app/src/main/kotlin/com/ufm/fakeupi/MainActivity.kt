package com.ufm.fakeupi

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Process
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.system.exitProcess

/**
 * Fake UPI Companion App - Test Harness Activity for UFM
 *
 * Implements NPCI upi://pay deep-link intent handling and simulates
 * payment outcomes: Success, Failure, Cancellation, Pending, and Crash.
 */
class MainActivity : AppCompatActivity() {

    private lateinit var tvStatus: TextView
    private lateinit var tvPa: TextView
    private lateinit var tvPn: TextView
    private lateinit var tvAm: TextView
    private lateinit var tvCu: TextView
    private lateinit var tvTn: TextView
    private lateinit var tvTr: TextView
    private lateinit var tvMc: TextView
    private lateinit var tvRawUri: TextView

    private lateinit var btnSuccess: Button
    private lateinit var btnFailure: Button
    private lateinit var btnCancel: Button
    private lateinit var btnCrash: Button
    private lateinit var btnPending: Button

    private var incomingUri: Uri? = null
    private var transactionRef: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        bindViews()
        setupListeners()
        processIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        processIntent(intent)
    }

    private fun bindViews() {
        tvStatus = findViewById(R.id.tvStatus)
        tvPa = findViewById(R.id.tvPa)
        tvPn = findViewById(R.id.tvPn)
        tvAm = findViewById(R.id.tvAm)
        tvCu = findViewById(R.id.tvCu)
        tvTn = findViewById(R.id.tvTn)
        tvTr = findViewById(R.id.tvTr)
        tvMc = findViewById(R.id.tvMc)
        tvRawUri = findViewById(R.id.tvRawUri)

        btnSuccess = findViewById(R.id.btnSuccess)
        btnFailure = findViewById(R.id.btnFailure)
        btnCancel = findViewById(R.id.btnCancel)
        btnCrash = findViewById(R.id.btnCrash)
        btnPending = findViewById(R.id.btnPending)
    }

    private fun setupListeners() {
        btnSuccess.setOnClickListener { simulateSuccess() }
        btnFailure.setOnClickListener { simulateFailure() }
        btnCancel.setOnClickListener { simulateCancel() }
        btnCrash.setOnClickListener { simulateCrash() }
        btnPending.setOnClickListener { simulatePending() }
    }

    private fun processIntent(intent: Intent?) {
        val uri = intent?.data
        incomingUri = uri

        if (uri != null && uri.scheme.equals("upi", ignoreCase = true) && uri.host.equals("pay", ignoreCase = true)) {
            val pa = uri.getQueryParameter("pa") ?: "None"
            val pn = uri.getQueryParameter("pn") ?: "None"
            val am = uri.getQueryParameter("am") ?: "None (Variable / User Input)"
            val cu = uri.getQueryParameter("cu") ?: "INR"
            val tn = uri.getQueryParameter("tn") ?: "None"
            val tr = uri.getQueryParameter("tr") ?: "None"
            val mc = uri.getQueryParameter("mc") ?: "None"

            transactionRef = if (tr != "None") tr else null

            tvStatus.text = "UPI Payment Intent Received"
            tvStatus.setTextColor(getColor(R.color.color_success))

            tvPa.text = pa
            tvPn.text = pn
            tvAm.text = if (am.contains("None")) am else "$am $cu"
            tvCu.text = cu
            tvTn.text = tn
            tvTr.text = tr
            tvMc.text = mc
            tvRawUri.text = uri.toString()

            setButtonsEnabled(true)
        } else {
            tvStatus.text = "Idle / No Active upi://pay Intent"
            tvStatus.setTextColor(getColor(R.color.text_secondary))

            tvPa.text = "—"
            tvPn.text = "—"
            tvAm.text = "—"
            tvCu.text = "—"
            tvTn.text = "—"
            tvTr.text = "—"
            tvMc.text = "—"
            tvRawUri.text = intent?.dataString ?: "(None - Launched as standalone app)"

            setButtonsEnabled(true)
        }
    }

    private fun setButtonsEnabled(enabled: Boolean) {
        btnSuccess.isEnabled = enabled
        btnFailure.isEnabled = enabled
        btnCancel.isEnabled = enabled
        btnCrash.isEnabled = enabled
        btnPending.isEnabled = enabled
    }

    private fun simulateSuccess() {
        val timestamp = SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
        val txnId = "FAKE_TXN_$timestamp"
        val approvalRefNo = "UTR${System.currentTimeMillis()}"
        val ref = transactionRef ?: "REF_$timestamp"

        val response = "txnId=$txnId&responseCode=00&ApprovalRefNo=$approvalRefNo&Status=SUCCESS&txnRef=$ref"
        deliverResult(Activity.RESULT_OK, response)
    }

    private fun simulateFailure() {
        val timestamp = SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
        val txnId = "FAKE_TXN_$timestamp"
        val ref = transactionRef ?: "REF_$timestamp"

        val response = "txnId=$txnId&responseCode=ZM&Status=FAILURE&txnRef=$ref"
        deliverResult(Activity.RESULT_OK, response)
    }

    private fun simulateCancel() {
        val response = "Status=FAILURE&responseCode=ZA"
        deliverResult(Activity.RESULT_CANCELED, response)
    }

    private fun simulateCrash() {
        Process.killProcess(Process.myPid())
        exitProcess(1)
    }

    private fun simulatePending() {
        val timestamp = SimpleDateFormat("yyyyMMddHHmmss", Locale.US).format(Date())
        val txnId = "FAKE_TXN_$timestamp"
        val approvalRefNo = "UTR${System.currentTimeMillis()}"
        val ref = transactionRef ?: "REF_$timestamp"

        val response = "txnId=$txnId&responseCode=01&ApprovalRefNo=$approvalRefNo&Status=SUBMITTED&txnRef=$ref"
        deliverResult(Activity.RESULT_OK, response)
    }

    private fun deliverResult(resultCode: Int, responseString: String) {
        val resultIntent = Intent().apply {
            putExtra("response", responseString)
            putExtra("Status", extractParam(responseString, "Status"))
            data = Uri.parse("upi://response?$responseString")
        }
        setResult(resultCode, resultIntent)
        finish()
    }

    private fun extractParam(queryString: String, key: String): String? {
        return queryString.split("&")
            .map { it.split("=") }
            .firstOrNull { it.size == 2 && it[0].equals(key, ignoreCase = true) }
            ?.get(1)
    }
}
