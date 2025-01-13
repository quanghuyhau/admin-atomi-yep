class ChoiceModel {
  String id;
  String textChoice;
  String imagePath;

  ChoiceModel({
    required this.id,
    required this.textChoice,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'textChoice': textChoice,
      'imagePath': imagePath,
    };
  }

  // Tạo từ bản đồ dữ liệu (không phải DocumentSnapshot trực tiếp)
  factory ChoiceModel.fromMap(Map<String, dynamic> map) {
    return ChoiceModel(
      id: map['id'] ?? '',
      textChoice: map['textChoice'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}
