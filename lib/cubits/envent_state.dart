import 'package:equatable/equatable.dart';
import '../../models/event.dart';

enum EventStatus { initial, loading, success, failure }

class EventState extends Equatable {
  final List<Event> events;
  final EventStatus status;
  final String? error;
  final Map<String, Map<int, int>> eventVotes;

  const EventState({
    this.events = const [],
    this.status = EventStatus.initial,
    this.error,
    this.eventVotes = const {},
  });

  EventState copyWith({
    List<Event>? events,
    EventStatus? status,
    String? error,
    Map<String, Map<int, int>>? eventVotes,
  }) {
    return EventState(
      events: events ?? this.events,
      status: status ?? this.status,
      error: error,
      eventVotes: eventVotes ?? this.eventVotes,
    );
  }

  @override
  List<Object?> get props => [events, status, error, eventVotes];
}
