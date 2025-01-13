import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/event.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadEventImage(File imageFile, String fileName) async {
    try {
      final ref = _storage.ref().child('event_images/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Không tải được hình ảnh: $e');
    }
  }

  Future<void> createEvent(EventModel event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
    } catch (e) {
      throw Exception('Không tạo được sự kiện: $e');
    }
  }

  Future<List<EventModel>> initListEvent() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("events").get();

      List<EventModel> eventList = snapshot.docs.map((doc) {
        return EventModel.fromFirestore(doc);
      }).toList();

      return eventList;
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  Stream<List<EventModel>> watchEvents() {
    return _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateEventStatus(String eventId, String status) async {
    try {
      await _firestore.collection('events').doc(eventId).update({'status': status});
    } catch (e) {
      throw Exception('Không cập nhật được trạng thái sự kiện: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Không thể xóa sự kiện: $e');
    }
  }

  Stream<Map<int, int>> watchEventVotes(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('votes')
        .snapshots()
        .map((snapshot) {
      final Map<int, int> boxVotes = {};
      for (var doc in snapshot.docs) {
        final List<int> selectedBoxes = List<int>.from(doc.data()['selectedBoxes'] ?? []);
        for (var boxIndex in selectedBoxes) {
          boxVotes[boxIndex] = (boxVotes[boxIndex] ?? 0) + 1;
        }
      }
      return boxVotes;
    });
  }
  Future<void> updateEventBoxNames(String eventId, List<String> boxNames) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'boxNames': boxNames,
      });
    } catch (e) {
      throw Exception('Không cập nhật được tên:  $e');
    }
  }

}
