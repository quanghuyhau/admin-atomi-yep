import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:admin_atomi_yep/cubits/envent_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'start':
                  await context.read<EventCubit>()
                      .updateEventStatus(event.id, 'active');
                  break;
                case 'stop':
                  await context.read<EventCubit>()
                      .updateEventStatus(event.id, 'closed');
                  break;
              }
            },
            itemBuilder: (context) => [
              if (event.status == 'pending')
                PopupMenuItem(
                  value: 'start',
                  child: Text('Bắt Đầu'),
                ),
              if (event.status == 'active')
                PopupMenuItem(
                  value: 'stop',
                  child: Text('Kết Thúc'),
                ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          final votes = state.eventVotes[event.id] ?? {};
          final totalVotes = votes.values.fold(0, (a, b) => a + b);

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              _buildStatusCard(event.status),
              SizedBox(height: 24),

              Text(
                'Kết Quả Bình Chọn',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                'Tổng số vote: $totalVotes',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 8, // 8 boxes
                itemBuilder: (context, index) {
                  final voteCount = votes[index] ?? 0;
                  final percentage = totalVotes > 0
                      ? (voteCount / totalVotes * 100).toStringAsFixed(1)
                      : '0.0';

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ô ${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$voteCount votes',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: color, size: 16),
            SizedBox(width: 8),
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
}