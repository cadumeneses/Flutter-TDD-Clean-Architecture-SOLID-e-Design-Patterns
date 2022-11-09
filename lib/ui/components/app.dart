import 'package:flutter/material.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Dev',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(136, 14, 79, 1),
        primaryColorDark: const Color.fromRGBO(96, 0, 39, 1),
        primaryColorLight: const Color.fromRGBO(188, 71, 79, 1),
        textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(96, 0, 39, 1))),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: Color.fromRGBO(188, 71, 79, 1),
          focusColor: Color.fromRGBO(136, 14, 79, 1),
          floatingLabelStyle: TextStyle(color: Color.fromRGBO(136, 14, 79, 1)),
          labelStyle: TextStyle(color: Color.fromRGBO(188, 71, 79, 1)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(188, 71, 79, 1),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(136, 14, 79, 1),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(136, 14, 79, 1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: const Color.fromRGBO(136, 14, 79, 1),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        )),
      ),
      debugShowCheckedModeBanner: false,
      // home:  const LoginPage(null),
    );
  }
}