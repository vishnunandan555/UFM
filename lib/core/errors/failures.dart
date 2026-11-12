sealed class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  final Object? cause;
  const DatabaseFailure(super.message, [this.cause]);

  @override
  String toString() => 'DatabaseFailure: $message (cause: $cause)';
}

class AccountNotFoundFailure extends Failure {
  final int accountId;
  const AccountNotFoundFailure(this.accountId)
      : super('Account with ID $accountId not found');

  @override
  String toString() => 'AccountNotFoundFailure: $message';
}

class InvalidAmountFailure extends Failure {
  final int amountPaise;
  const InvalidAmountFailure(this.amountPaise, [String? message])
      : super(
          message ??
              'Amount must be strictly positive (got $amountPaise paise)',
        );

  @override
  String toString() => 'InvalidAmountFailure: $message';
}

class SameAccountTransferFailure extends Failure {
  final int accountId;
  const SameAccountTransferFailure(this.accountId)
      : super('Source and destination accounts must be distinct (both are $accountId)');

  @override
  String toString() => 'SameAccountTransferFailure: $message';
}

class DuplicatePaymentConfirmationFailure extends Failure {
  final int paymentAttemptId;
  const DuplicatePaymentConfirmationFailure(this.paymentAttemptId)
      : super('Payment attempt $paymentAttemptId is already confirmed or linked');

  @override
  String toString() => 'DuplicatePaymentConfirmationFailure: $message';
}

