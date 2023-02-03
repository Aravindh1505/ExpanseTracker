class PaymentMode {
  final String documentId;
  final int payId;
  final String payName;
  final int sequence;
  final bool isActive;

  PaymentMode({
    required this.documentId,
    required this.payId,
    required this.payName,
    required this.sequence,
    required this.isActive,
  });
}
