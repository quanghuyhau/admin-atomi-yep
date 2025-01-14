import 'package:admin_atomi_yep/constants/app_colors.dart';
import 'package:admin_atomi_yep/constants/app_text_style.dart';
import 'package:admin_atomi_yep/constants/images_constants.dart';
import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/envent_state.dart';
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
        title: Text(
          'Tạo Sự Kiện Mới',
          style: AppTextStyles.heading1,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
            )),
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              onChanged: (value) {
                context.read<EventCubit>().updateNameEvent(valueName: value);
              },
              decoration: InputDecoration(
                labelText: 'Tên Sự Kiện',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: Icon(Icons.event),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Vui lòng nhập tên sự kiện';
                }
                return null;
              },
            ),
          ),
          Expanded(child: _choiceWidget()),
          SizedBox(height: 24),
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
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final event = EventModel(
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

  Widget _choiceWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (int i = 0; i < 8; i++) _itemChoiceWidget(index: i)
              ],
            )),
      ),
    );
  }

  Widget _itemChoiceWidget({required int index}) {
    return Card(
      color: AppColors.white,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              // width: 120,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Lựa chọn ${index + 1}',
                  filled: true,
                  fillColor: AppColors.backgroundTextField,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onChanged: (value) {
                  context
                      .read<EventCubit>()
                      .updateValueChoice(valueChoice: value, index: index);
                },
              ),
            ),
            InkWell(
              onTap: () async {
                final String? result = await showCustomDialog(context);
                context.read<EventCubit>().updateImagePathChoice(
                    imagePath: result ?? Images.n1, index: index);
              },
              child: BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      state.currentEventCreate?.listChoice[index].imagePath ??
                          "assets/images/1.jpg",
                      height: 90,
                      width: 90,
                      fit: BoxFit.fill,
                    ));
              }),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> showCustomDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn Ảnh'),
          content: GridView.builder(
              itemCount: listFake.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(listFake[index]);
                    setState(() {});
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(listFake[index])),
                );
              }),
        );
      },
    );
  }
}
