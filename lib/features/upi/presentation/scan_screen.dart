import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../parser/upi_uri_parser.dart';
import 'qr_review_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(String rawValue) {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final result = UpiUriParser.parse(rawValue);

    if (result is UpiParseSuccess) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => QrReviewScreen(draft: result.draft),
            ),
          )
          .then((_) => setState(() => _isProcessing = false));
    } else if (result is UpiParseFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid UPI QR: ${result.reason}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isProcessing = false);
      });
    }
  }

  void _showManualEntryDialog() {
    final controller = TextEditingController(
      text: 'upi://pay?pa=merchant@upi&pn=Coffee%20Roasters&am=150.00&cu=INR',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Test / Paste UPI URI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'For emulator testing or manual input, paste a UPI payment URI below:',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'UPI URI',
                hintText: 'upi://pay?pa=...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleBarcode(controller.text.trim());
            },
            child: const Text('Test / Parse'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan UPI QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Toggle Torch',
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            tooltip: 'Switch Camera',
            onPressed: () => _controller.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.paste),
            tooltip: 'Manual URI Input',
            onPressed: _showManualEntryDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final rawValue = barcode.rawValue;
                if (rawValue != null && rawValue.isNotEmpty) {
                  _handleBarcode(rawValue);
                  break;
                }
              }
            },
          ),

          // Viewfinder Overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Instructions at Bottom
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.black.withValues(alpha: 0.7),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code, color: Colors.white70),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Align merchant QR code inside the frame or tap paste',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
