import 'dart:async';
import 'package:admin_atomi_yep/cubits/envent_state.dart';
import 'package:admin_atomi_yep/models/event.dart';
import 'package:admin_atomi_yep/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {
  final FirebaseService _firebaseService;
  StreamSubscription? _eventsSubscription;
  Map<String, StreamSubscription> _voteSubscriptions = {};

  EventCubit(this._firebaseService) : super(EventState()) {
    _watchEvents();
  }

  void _watchEvents() {
    emit(state.copyWith(status: EventStatus.loading));

    _eventsSubscription?.cancel();
    _eventsSubscription = _firebaseService.watchEvents().listen(
          (events) {
        emit(state.copyWith(
          events: events,
          status: EventStatus.success,
        ));

        // Watch votes for active events
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
      },
    );
  }

  void _watchEventVotes(String eventId) {
    _voteSubscriptions[eventId]?.cancel();
    _voteSubscriptions[eventId] = _firebaseService
        .watchEventVotes(eventId)
        .listen((votes) {
      final newEventVotes = Map<String, Map<int, int>>.from(state.eventVotes);
      newEventVotes[eventId] = votes;
      emit(state.copyWith(eventVotes: newEventVotes));
    });
  }

  Future<void> createEvent(Event event) async {
    try {
      await _firebaseService.createEvent(event);
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

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _voteSubscriptions.values.forEach((sub) => sub.cancel());
    return super.close();
  }
}