import 'package:admin_atomi_yep/constants/app_colors.dart';
import 'package:admin_atomi_yep/constants/app_text_style.dart';
import 'package:admin_atomi_yep/constants/images_constants.dart';
import 'package:admin_atomi_yep/main.dart';
import 'package:admin_atomi_yep/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validateNext = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.backgroundFirstScreen),
                  fit: BoxFit.cover,
                )),
          ),
          _center()
        ],
      ),
    );
  }

  Widget _center() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Đảm bảo sử dụng Form để xác thực
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                cursorColor: AppColors.blue,
                controller: _controller,
                onChanged: (value) {
                  // Kiểm tra nếu giá trị trống
                  if (value == null || value.isEmpty) {
                    setState(() {
                      validateNext = false; // Nếu trống, không hợp lệ
                    });
                  } else {
                    setState(() {
                      validateNext = true; // Nếu có giá trị, hợp lệ
                    });
                  }
                  return null; // Nếu không có lỗi, trả về null
                },
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  // Nhãn
                  hintText: 'John Doe',
                  // Gợi ý
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                  ),
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                onPressed: () {
                  // Kiểm tra lại tính hợp lệ của form
                  if (_formKey.currentState!.validate()) {
                    // Nếu hợp lệ, chuyển sang màn hình khác
                    nameAccount = _controller.text;
                    if (_controller.text == AdminAccount.admin) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    } else {
                      print("user");
                    }
                  } else {
                    // Nếu không hợp lệ, không làm gì cả
                    setState(() {
                      validateNext = false; // Nếu không hợp lệ, giữ màu xám
                    });
                  }
                },
                icon: Icon(
                  Icons.double_arrow_sharp,
                  size: 50,
                  color: validateNext ? Colors.white : Colors
                      .grey, // Màu trắng nếu hợp lệ, xám nếu không
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
