import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/event.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> uploadEventImage(File imageFile, String fileName) async {
    final ref = _storage.ref().child('event_images/$fileName.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  Stream<List<Event>> watchEvents() {
    return _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Event.fromFirestore(doc))
        .toList());
  }

  Future<void> updateEventStatus(String eventId, String status) async {
    await _firestore.collection('events').doc(eventId).update({
      'status': status,
    });
  }

  Stream<Map<int, int>> watchEventVotes(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('votes')
        .snapshots()
        .map((snapshot) {
      Map<int, int> boxVotes = {};
      for (var doc in snapshot.docs) {
        List<int> selectedBoxes =
        List<int>.from(doc.data()['selectedBoxes'] ?? []);
        for (var boxIndex in selectedBoxes) {
          boxVotes[boxIndex] = (boxVotes[boxIndex] ?? 0) + 1;
        }
      }
      return boxVotes;
    });
  }
}