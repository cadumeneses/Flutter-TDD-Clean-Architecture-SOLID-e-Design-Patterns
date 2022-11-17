import 'package:flutter/material.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  final primaryColor = const Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = const Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = const Color.fromRGBO(188, 71, 79, 1);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Dev',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(136, 14, 79, 1),
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        textTheme: TextTheme(
            headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: primaryColorDark,
        )),
        inputDecorationTheme: InputDecorationTheme(
          iconColor: primaryColorLight,
          focusColor: primaryColor,
          floatingLabelStyle: TextStyle(color: primaryColor),
          labelStyle: TextStyle(color: primaryColorLight),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColorLight,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        )),
      ),
      debugShowCheckedModeBanner: false,
      // home:  const LoginPage(null),
    );
  }
}
