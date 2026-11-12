abstract interface class TransferService {
  Future<int> executeTransfer({
    required int sourceAccountId,
    required int destinationAccountId,
    required int amountPaise,
    required DateTime occurredAt,
    String? note,
  });
}

