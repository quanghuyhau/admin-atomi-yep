import 'dart:async';
import 'package:admin_atomi_yep/constants/images_constants.dart';
import 'package:admin_atomi_yep/cubits/envent_state.dart';
import 'package:admin_atomi_yep/models/choice_model.dart';
import 'package:admin_atomi_yep/models/event.dart';
import 'package:admin_atomi_yep/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {
  final FirebaseService _firebaseService;
  StreamSubscription? _eventsSubscription;
  Map<String, StreamSubscription> _voteSubscriptions = {};

  EventModel eventModel = EventModel(
      id: "",
      name: "",
      status: "pending",
      createdAt: DateTime.now(),
      listChoice: [
        ChoiceModel(id: "1", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "2", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "3", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "4", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "5", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "6", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "7", textChoice: "", imagePath: Images.n1),
        ChoiceModel(id: "8", textChoice: "", imagePath: Images.n1),
      ]);

  EventCubit(this._firebaseService) : super(EventState()) {
    watchEvents();
  }

  void watchEvents() {
    emit(state.copyWith(status: EventStatus.loading));

    _eventsSubscription?.cancel();
    _eventsSubscription = _firebaseService.watchEvents().listen(
      (events) {
        emit(state.copyWith(
          events: events,
          status: EventStatus.success,
        ));

        for (var event in events) {
          if (event.status == 'active') {
            _watchEventVotes(event.id);
          }
        }
      },
      onError: (error) {
        emit(state.copyWith(
          error: error.toString(),
          status: EventStatus.failure,
        ));
        print(error.toString() + "sadjkdafkasdf");
      },
    );
  }

  void initListEvent() async {
    emit(state.copyWith(status: EventStatus.loading));
    final events = await _firebaseService.initListEvent();
    emit(state.copyWith(
      events: events,
      status: EventStatus.success,
    ));
  }

  void _watchEventVotes(String eventId) {
    _voteSubscriptions[eventId]?.cancel();
    _voteSubscriptions[eventId] =
        _firebaseService.watchEventVotes(eventId).listen((votes) {
      final newEventVotes = Map<String, Map<int, int>>.from(state.eventVotes);
      newEventVotes[eventId] = votes;
      emit(state.copyWith(eventVotes: newEventVotes));
    });
  }

  Future<void> createEvent(EventModel event) async {
    try {
      // await _firebaseService.createEvent(event);
      await _firebaseService.createEvent(eventModel);
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: EventStatus.failure,
      ));
    }
  }

  Future<void> updateEventStatus(String eventId, String status) async {
    try {
      await _firebaseService.updateEventStatus(eventId, status);
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: EventStatus.failure,
      ));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firebaseService.deleteEvent(eventId);
      _voteSubscriptions[eventId]?.cancel();
      _voteSubscriptions.remove(eventId);
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: EventStatus.failure,
      ));
    }
  }

  void updateValueChoice({required String valueChoice, required int index}) {
    eventModel.listChoice[index].textChoice = valueChoice;
  }

  void updateNameEvent({required String valueName}) {
    eventModel.name = valueName;
  }

  Future<void> updateImagePathChoice(
      {required String imagePath, required int index}) async {
    eventModel.listChoice[index].imagePath = imagePath;
    print(eventModel.listChoice[index].imagePath + "ASASASAS");
    emit(state.copyWith(
        currentEventCreate: eventModel, status: EventStatus.updateImage));
  }

  // Future<void> updateBoxName(String eventId, int index, String newName) async {
  //   try {
  //     final event = state.events.firstWhere((e) => e.id == eventId);
  //     final updatedBoxNames = List<String>.from(event.listChoice);
  //
  //     if (updatedBoxNames.length > index) {
  //       updatedBoxNames[index] = newName;
  //     } else {
  //       while (updatedBoxNames.length <= index) {
  //         updatedBoxNames.add('');
  //       }
  //       updatedBoxNames[index] = newName;
  //     }
  //
  //     await _firebaseService.updateEventBoxNames(eventId, updatedBoxNames);
  //
  //     final updatedEvents = state.events.map((e) {
  //       if (e.id == eventId) {
  //         return e.copyWith(boxNames: updatedBoxNames);
  //       }
  //       return e;
  //     }).toList();
  //
  //     emit(state.copyWith(events: updatedEvents));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       error: e.toString(),
  //       status: EventStatus.failure,
  //     ));
  //   }
  // }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _voteSubscriptions.values.forEach((sub) => sub.cancel());
    return super.close();
  }
}
