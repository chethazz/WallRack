import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regwalls/views/home.dart';
import 'package:flutter/services.dart';
import 'package:regwalls/widget/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WallRack());
}

class WallRack extends StatelessWidget {
  const WallRack({super.key});

  void setSystemNavBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        systemNavigationBarIconBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WallRack',
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.black,
          textTheme: GoogleFonts.poppinsTextTheme(),
          brightness: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
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
      ),
    );
  }
}
