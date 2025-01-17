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
    listChoice: [],
  );

  EventCubit(this._firebaseService) : super(EventState()) {
    watchEvents();
  }

  // Theo dõi sự kiện từ Firebase
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
        print('Error watching events: $error');
      },
    );
  }

  // Khởi tạo danh sách sự kiện
  Future<void> initListEvent() async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final events = await _firebaseService.initListEvent();
      emit(state.copyWith(
        events: events,
        status: EventStatus.createSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: EventStatus.failure,
      ));
    }
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

  Future<void> createEvent(List<ChoiceModel> listChoiceEvent) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));

      eventModel.listChoice.clear();
      eventModel.listChoice.addAll(listChoiceEvent);

      await _firebaseService.createEvent(eventModel);

      emit(state.copyWith(status: EventStatus.createSuccess));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: EventStatus.failure,
      ));
      print('Error creating event: $e');
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

  void updateNameEvent({required String valueName}) {
    eventModel.name = valueName;
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _voteSubscriptions.values.forEach((sub) => sub.cancel());
    return super.close();
  }
}
