import 'package:admin_atomi_yep/constants/app_colors.dart';
import 'package:admin_atomi_yep/constants/app_text_style.dart';
import 'package:admin_atomi_yep/models/event.dart';
import 'package:admin_atomi_yep/screens/event_detail_screen.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onDelete;
  final int index;

  const EventCard(
      {required this.event, required this.onDelete, required this.index});

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   margin: EdgeInsets.only(bottom: 16),
    //   child: InkWell(
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (_) => EventDetailScreen(event: event),
    //         ),
    //       );
    //     },
    //     child: Padding(
    //       padding: EdgeInsets.all(16),
    //       child: Row(
    //         children: [
    //           // Event Icon
    //           Container(
    //             width: 60,
    //             height: 60,
    //             decoration: BoxDecoration(
    //               color: Theme
    //                   .of(context)
    //                   .primaryColor
    //                   .withOpacity(0.1),
    //               borderRadius: BorderRadius.circular(12),
    //             ),
    //             child: Icon(
    //               Icons.event,
    //               color: Theme
    //                   .of(context)
    //                   .primaryColor,
    //               size: 32,
    //             ),
    //           ),
    //           SizedBox(width: 16),
    //
    //           // Event Info
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   event.name,
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(height: 8),
    //                 _buildStatusChip(event.status),
    //               ],
    //             ),
    //           ),
    //
    //           IconButton(
    //             icon: Icon(
    //               Icons.delete,
    //               color: Colors.red,
    //             ),
    //             onPressed: () {
    //               _showDeleteConfirmation(context);
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return _card(context);
  }

  _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = Colors.green;
        text = 'Đang Diễn Ra';
        break;
      case 'pending':
        color = Colors.orange;
        text = 'Sắp Diễn Ra';
        break;
      default:
        color = Colors.grey;
        text = 'Đã Kết Thúc';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa Sự Kiện'),
        content: Text('Bạn có chắc muốn xóa sự kiện này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Container(
      // height: 80,
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailScreen(event: event),
                  ),
                );
              },
              child: _headCard()),
          Container(
            margin: EdgeInsets.only(left: 2),
            width: 1,
            color: AppColors.primaryColor,
            height: 60,
          ),
          Container(
            margin: EdgeInsets.only(left: 2),
            width: 1,
            color: AppColors.primaryColor,
            height: 40,
          ),
          Expanded(child: _bodyCard()),
          _deleteButton(context)
        ],
      ),
    );
  }

  Widget _headCard() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 2, color: AppColors.primaryColor)),
      // padding: EdgeInsets.all(24),
      child: Center(
          child: Text(
        (index + 1).toString(),
        style: AppTextStyles.numberBig,
      )),
    );
  }

  Widget _bodyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            event.name,
            style: AppTextStyles.bodyText1,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildStatusChip(event.status),
        ),
      ],
    );
  }

  Widget _deleteButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDeleteConfirmation(context);
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: AppColors.primaryColor)),
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.delete_outline,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
