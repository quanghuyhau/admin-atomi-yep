import 'package:admin_atomi_yep/constants/app_colors.dart';
import 'package:admin_atomi_yep/constants/app_text_style.dart';
import 'package:admin_atomi_yep/constants/images_constants.dart';
import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:admin_atomi_yep/models/choice_model.dart';
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
  List<ChoiceModel> listCh = [
    // ChoiceModel(id: "1", textChoice: "Phong 1", imagePath: Images.n1),
  ];
  List<ChoiceModel> listLocalChoice = [];

  @override
  void initState() {
    listLocalChoice.addAll(listChoice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          onPressed: () {
            showCustomDialog(context);
          }),
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
      body: BlocListener<EventCubit, EventState>(
        listener: (context,state) {
          if(state.status == EventStatus.success){
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<EventCubit, EventState>(builder: (context, state) {
          if(state.status ==EventStatus.loading)
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          return Column(
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
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
              SizedBox(height: 18),
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
              SizedBox(height: 18),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _createEvent() async {
    // if (!_formKey.currentState!.validate()) return;
    //
    // setState(() => _isLoading = true);

    try {
      // final event = EventModel(
      //   id: '',
      //   name: _nameController.text,
      //   status: 'pending',
      //   createdAt: DateTime.now(),
      // );

      await context.read<EventCubit>().createEvent(listCh);

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

  // Future<void> _createEvent() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return; // Exit if form is invalid.
  //   }
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     await context.read<EventCubit>().createEvent(listCh); // Create event.
  //     Navigator.pop(context);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Tạo sự kiện thành công!')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Lỗi: ${e.toString()}')),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Widget _choiceWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: listCh.length,
          itemBuilder: (context, index) {
            return _itemChoiceWidget(index: index);
          }),
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
                child: Text(
              listCh[index].textChoice,
              style: AppTextStyles.bodyText1,
            )),
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  listCh[index].imagePath,
                  height: 90,
                  width: 90,
                  fit: BoxFit.fill,
                ))
          ],
        ),
      ),
    );
  }

  Future showCustomDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            height: 500, // Đặt chiều cao cố định hoặc linh hoạt tùy nhu cầu
            child: GridView.builder(
              padding: EdgeInsets.all(6),
              itemCount: listLocalChoice.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7

              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ChoiceModel element = listLocalChoice.removeAt(index);
                    listCh.add(element);
                    Navigator.of(context).pop();
                    setState(() {}); // Cập nhật UI sau khi chọn ảnh
                  },
                  child: _itemDialog(choiceModel: listLocalChoice[index])
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _itemDialog({ required ChoiceModel choiceModel}) {
    return Container(
      width: 120,
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Màu bóng
            offset: Offset(1, 1), // Vị trí đổ bóng (horizontally, vertically)
            blurRadius: 1, // Mờ bóng
            spreadRadius: 0, // Mở rộng bóng
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white
      ),
      child: Column(
        children: [
           ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8),),
            child: Image.asset(choiceModel.imagePath,width: 120,height: 120,fit: BoxFit.fill  ,),
          ),
          Expanded(child: Center(child: Text(choiceModel.textChoice,style: AppTextStyles.caption,)))
        ],
      ),
    );
  }
}
