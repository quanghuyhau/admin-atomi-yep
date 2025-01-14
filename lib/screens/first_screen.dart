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
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                cursorColor: AppColors.blue,
                controller: _controller,
                onChanged: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      validateNext = false;
                    });
                  } else {
                    setState(() {
                      validateNext = true;
                    });
                  }
                  return null;
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
                  if (_formKey.currentState!.validate()) {
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
                    setState(() {
                      validateNext = false;
                    });
                  }
                },
                icon: Icon(
                  Icons.double_arrow_sharp,
                  size: 50,
                  color: validateNext ? Colors.white : Colors
                      .grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
