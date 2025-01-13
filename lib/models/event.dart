import 'package:admin_atomi_yep/models/choice_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String name;
  String status;
  DateTime createdAt;
  List<ChoiceModel> listChoice;

  EventModel({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    this.listChoice = const [],
  });

  EventModel copyWith({
    String? id,
    String? name,
    String? status,
    DateTime? createdAt,
    List<ChoiceModel>? boxNames,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      listChoice: boxNames ?? this.listChoice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'boxNames': listChoice.map((e) => e.toMap()).toList(),
    };
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Khởi tạo listChoice từ dữ liệu trong Firestore
    List<ChoiceModel> choiceList = [];
    if (data['boxNames'] != null && data['boxNames'] is List) {
      choiceList = (data['boxNames'] as List)
          .map((choiceData) => ChoiceModel.fromMap(choiceData))
          .toList();
    }

    return EventModel(
      id: doc.id,
      name: data['name'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      listChoice: choiceList,
    );
  }
}
