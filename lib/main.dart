import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regwalls/views/home.dart';
import 'package:flutter/services.dart';
import 'package:regwalls/widget/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RegWalls',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            SharedPreferences? prefs = snapshot.data;
            bool isFirstRun = prefs?.getBool('isFirstRun') ?? false;
            if (!isFirstRun) {
              prefs?.setBool('isFirstRun', true);
            }
            return isFirstRun ? const Home() : const OnBoard();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
