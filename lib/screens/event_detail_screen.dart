import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/envent_cubit.dart';
import '../cubits/envent_state.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        centerTitle: true,
        actions: [
          _action(context),
        ],
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          final votes = state.eventVotes[event.id] ?? {};
          final totalVotes = votes.values.fold(0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _nameEvents(context),
              const SizedBox(height: 16),
              _buildStatusCard(event.status),
              const SizedBox(height: 24),
              Text(
                'Kết Quả Bình Chọn',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Tổng số vote: $totalVotes',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ...List.generate(8, (index) {
                // String boxName = event.boxNames.length > index
                //     ? event.boxNames[index]
                //     : 'Ô ${index + 1}';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Image.asset(
                            event.listChoice[index].imagePath,
                            width: 40,
                            height: 40,
                          ),
                          Expanded(
                            child: Center(child: Text(event.listChoice[index].textChoice)),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${votes[index] ?? 0} votes',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              _saveBoxEvent(context)
            ],
          );
        },
      ),
    );
  }

  _buildStatusCard(String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Đang Diễn Ra';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Chưa Bắt Đầu';
        break;
      default:
        color = Colors.grey;
        text = 'Đã Kết Thúc';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _action(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'start':
            await context
                .read<EventCubit>()
                .updateEventStatus(event.id, 'active');
            break;
          case 'stop':
            await context
                .read<EventCubit>()
                .updateEventStatus(event.id, 'closed');
            break;
        }
      },
      itemBuilder: (context) => [
        if (event.status == 'pending')
          const PopupMenuItem(
            value: 'start',
            child: Text('Bắt Đầu'),
          ),
        if (event.status == 'active')
          const PopupMenuItem(
            value: 'stop',
            child: Text('Kết Thúc'),
          ),
      ],
    );
  }

  _nameEvents(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.event,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveBoxEvent(BuildContext context) {
    return ElevatedButton(
      onPressed: event.listChoice.length == 8
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu thành công!')),
              );
            }
          : null,
      child: const Text('Lưu'),
    );
  }
}
