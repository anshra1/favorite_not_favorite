class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film filmUpdate({required bool isFavorite}) {
    return Film(
        id: id, title: title, description: description, isFavorite: isFavorite);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Film &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ isFavorite.hashCode;
}
