class Categories {
  final String documentId;
  final int categoryId;
  final String categoryName;
  late final String type;
  final int sequence;
  final bool isActive;

  Categories({
    required this.documentId,
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.sequence,
    required this.isActive,
  });
}
