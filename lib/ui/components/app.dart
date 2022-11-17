import 'package:flutter/material.dart';
import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeData makeAppTheme() {
    const primaryColor = Color.fromARGB(255, 250, 198, 226);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
    const secondaryColor = Color.fromRGBO(0, 77, 64, 1);
    const secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);
    final disabledColor = Colors.grey[400];
    const dividerColor = Colors.grey;
    const textTheme = TextTheme(
        headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark));
    const inputDecorationTheme = InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColorLight)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      alignLabelWithHint: true,
    );
    final buttonTheme = ButtonThemeData(
      colorScheme: const ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      highlightColor: secondaryColor,
      secondaryHeaderColor: secondaryColorDark,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.light(primary: primaryColor),
      backgroundColor: Colors.white,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      buttonTheme: buttonTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4Dev',
      theme: makeAppTheme(),
      debugShowCheckedModeBanner: false,
      // home:  const LoginPage(null),
    );
  }
}
