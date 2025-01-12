import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/event.dart';
import '../services/firebase_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Sự Kiện Mới'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Event Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên Sự Kiện',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập tên sự kiện';
                }
                return null;
              },
            ),
            SizedBox(height: 24),

            // Create Button
            ElevatedButton(
              onPressed: _isLoading ? null : _createEvent,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Tạo Sự Kiện',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create new event
      final event = Event(
        id: '',
        name: _nameController.text,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await context.read<EventCubit>().createEvent(event);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo sự kiện thành công!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}