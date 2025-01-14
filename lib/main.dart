import 'package:admin_atomi_yep/cubits/envent_cubit.dart';
import 'package:admin_atomi_yep/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/app_colors.dart';
import 'services/firebase_service.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

String nameAccount = "";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
        ),
        BlocProvider(
          create: (context) => EventCubit(context.read<FirebaseService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Admin App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          appBarTheme: AppBarTheme(
            color: AppColors.primaryColor, // Màu của AppBar
          ),
        ),
        home: FirstScreen(),
        // home:  HomeScreen(),
      ),
    );
  }
}
