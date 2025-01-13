import 'package:equatable/equatable.dart';
import '../../models/event.dart';

enum EventStatus { initial, loading, success, failure, updateImage }

class EventState extends Equatable {
  final List<EventModel> events;
  final EventStatus status;
  final String? error;
  final EventModel? currentEventCreate;
  final Map<String, Map<int, int>> eventVotes;

  const EventState({
    this.events = const [],
    this.status = EventStatus.initial,
    this.error,
    this.currentEventCreate,
    this.eventVotes = const {},
  });

  EventState copyWith({
    List<EventModel>? events,
    EventStatus? status,
    String? error,
    EventModel? currentEventCreate,
    Map<String, Map<int, int>>? eventVotes,
  }) {
    return EventState(
      events: events ?? this.events,
      status: status ?? this.status,
      error: error,
      currentEventCreate: currentEventCreate ?? this.currentEventCreate,
      eventVotes: eventVotes ?? this.eventVotes,
    );
  }

  @override
  List<Object?> get props =>
      [events, status, error, eventVotes, currentEventCreate];
}
