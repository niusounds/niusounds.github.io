class BbsEntry {
  final String? id;
  final String name;
  final String title;
  final String body;
  final int textColor;
  final String deleteKey;
  final DateTime? updatedAt;

  const BbsEntry({
    required this.name,
    required this.title,
    required this.body,
    required this.textColor,
    required this.deleteKey,
    this.id,
    this.updatedAt,
  });
}
