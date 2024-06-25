import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData myTheme(BuildContext context){
  return ThemeData(
        primaryColor: Colors.white,
        colorScheme: const ColorScheme(
          primary:  Colors.white,
          secondary: Colors.white,
          surface:  Color.fromARGB(255, 44, 55, 118),
          surfaceTint:  Color.fromARGB(255, 44, 55, 118),
          error:  Colors.red,
          onPrimary:  Color.fromARGB(255, 44, 55, 118),
          onSecondary:  Color.fromARGB(255, 44, 55, 118),
          onSurface:  Colors.white,
          onError:  Color.fromARGB(255, 22, 28, 60),
          brightness: Brightness.light,
        ),
        hintColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 17, 42),
        dialogBackgroundColor: const Color.fromARGB(255, 33, 42, 90),
        popupMenuTheme: const PopupMenuThemeData(color: Color.fromARGB(255, 33, 42, 90)),
        datePickerTheme: const DatePickerThemeData(backgroundColor: Color.fromARGB(255, 33, 42, 90)),
        textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
);
}