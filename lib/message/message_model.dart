class MessageModel {
  String title;

  MessageModel({
    required this.title,
  });

  Map<String, dynamic> toMap() => {'title': title};

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(title: map['title']);
  }
}
