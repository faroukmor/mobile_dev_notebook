class Note {
  int? id;
  String title;
  String content;
  int? categoryId;
  bool favorite;
  String createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.favorite = false,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category_id': categoryId,
      'is_favorite': favorite ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      categoryId: map['category_id'],
      favorite: map['is_favorite'] == 1,
      createdAt: map['created_at'],
    );
  }
}

class Category {
  int id;
  String name;

  Category({required this.id, required this.name});
}