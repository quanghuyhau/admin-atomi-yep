import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_style.dart';
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
        title: Text(
          event.name,
          style: AppTextStyles.heading1,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          _action(context),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      // body: BlocBuilder<EventCubit, EventState>(
      //   builder: (context, state) {
      //     final votes = state.eventVotes[event.id] ?? {};
      //     final totalVotes = votes.values.fold(0, (a, b) => a + b);
      //
      //     return ListView(
      //       padding: const EdgeInsets.all(16),
      //       children: [
      //         const SizedBox(height: 16),
      //         _buildStatusCard(event.status),
      //         const SizedBox(height: 24),
      //         Text(
      //           'Kết Quả Bình Chọn',
      //           style: Theme.of(context).textTheme.titleLarge,
      //         ),
      //
      //         const SizedBox(height: 8),
      //         Text(
      //           'Tổng số vote: $totalVotes',
      //           style: TextStyle(color: Colors.grey[600]),
      //         ),
      //         const SizedBox(height: 16),
      //         ...List.generate(8, (index) {
      //           // String boxName = event.boxNames.length > index
      //           //     ? event.boxNames[index]
      //           //     : 'Ô ${index + 1}';
      //
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 8.0),
      //             child: Card(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(12),
      //               ),
      //               child: Padding(
      //                 padding: const EdgeInsets.all(16),
      //                 child: Column(
      //                   children: [
      //                     Image.asset(
      //                       event.listChoice[index].imagePath,
      //                       width: 40,
      //                       height: 40,
      //                     ),
      //                     Center(
      //                         child: Text(event.listChoice[index].textChoice)),
      //                     const SizedBox(width: 16),
      //                     Text(
      //                       '${votes[index] ?? 0} votes',
      //                       style: TextStyle(
      //                         color: Theme.of(context).primaryColor,
      //                         fontSize: 16,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         }),
      //         const SizedBox(height: 24),
      //         _listVote()
      //       ],
      //     );
      //   },
      // ),

      body: _listVote(),
    );
  }

  Widget _listVote() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          final votes = state.eventVotes[event.id] ?? {};
          final totalVotes = votes.values.fold(0, (a, b) => a + b);

          return Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Tổng số vote: $totalVotes',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: event.listChoice.length, // Số phần tử trong lưới
                  itemBuilder: (BuildContext context, int index) {
                    return _item(
                        imagePath: event.listChoice[index].imagePath,
                        textChoice: event.listChoice[index].textChoice,
                        voteIndex: votes[index] ?? 0);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _item(
      {required String imagePath,
      required String textChoice,
      required int voteIndex}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(textChoice),
          ),
          const SizedBox(width: 16),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$voteIndex',
              style: AppTextStyles.bodyText1
            ),
          ),
        ],
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
      color: AppColors.white,
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
}
