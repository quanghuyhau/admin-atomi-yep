import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:admin_atomi_yep/cubits/envent_state.dart';
import 'package:admin_atomi_yep/screens/event_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/event.dart';
import 'create_event_screen.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Sự Kiện'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateEventScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state.status == EventStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có sự kiện nào',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return EventCard(event: event);
            },
          );
        },
      ),
    );
  }
}

