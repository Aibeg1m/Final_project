import 'package:final_project/pages/first_login.dart';
import 'package:final_project/pages/home_screen.dart';
import 'package:final_project/pages/main_page.dart';
import 'package:final_project/pages/second_login.dart';
import 'package:final_project/pages/third_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FirstLogin(),
        '/signUp': (context) => SecondLogin(),
        '/signIn': (context) => ThirdLogin(),
        '/main_page': (context) => MainPage(),
      },
    );
  }
}
