import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  //ThemeMode themeMode = ThemeMode.system;
  bool dark = false;
  // bool get isDarkMode {
  //   if (themeMode == ThemeMode.system) {
  //     final brightness = SchedulerBinding.instance.window.platformBrightness;
  //     return brightness == Brightness.dark;
  //   } else {
  //     return themeMode == ThemeMode.dark;
  //   }
  // }

  Future<void> toggleTheme(bool d) async {
    dark = d;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("dark", d);
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    //scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    backgroundColor: Colors.black,

    //iconTheme: IconThemeData(color: Constants.maincolor, opacity: 0.8),
    //textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
  );

  static final lightTheme = ThemeData(
    //scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    backgroundColor: Colors.white,
    //iconTheme: IconThemeData(color: Constants.maincolor, opacity: 0.8),
    //textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
  );
}
