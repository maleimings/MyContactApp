class ContactItem {
  final int id;
  final String name;
  final String cellphone;
  final String telephone;
  final bool favorite;

  ContactItem(
      {required this.id,
      required this.name,
      required this.cellphone,
      required this.telephone,
      required this.favorite});

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
        id: json['id'],
        name: json['name'],
        cellphone: json['cellphone'],
        telephone: json['telephone'],
        favorite: json['favorite']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cellphone': cellphone,
      'telephone': telephone,
      'isFavorite': favorite ? 1 : 0
    };
  }
}
