import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regwalls/views/home.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/onboard.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 16,
                margin: const EdgeInsets.only(top: 150),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.ubuntu().fontFamily,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Wall',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Rack',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height/2.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          stops: [0.2, 0.8],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 18),
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 100),
                        height: MediaQuery.of(context).size.height / 10,
                        child: const Text(
                          'Your wallpaper defines your personality....'
                          '\nAre you ready to define yourself?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(100, 100, 100, 0.4),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                      ),
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 150), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18)),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        height: 50,
                        child: const Text('Move on', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
