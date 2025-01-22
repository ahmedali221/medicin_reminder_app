class Topic {
  final String type;
  final String id;
  final String title;
  final int parentId;
  final String translationId;

  Topic({
    required this.type,
    required this.id,
    required this.title,
    required this.parentId,
    required this.translationId,
  });

  // Factory method to parse JSON into a Topic object
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      type: json['Type'],
      id: json['Id'].toString(),
      title: json['Title'],
      parentId: json['ParentId'] ?? -1,
      translationId: json['TranslationId'].toString(),
    );
  }
}
