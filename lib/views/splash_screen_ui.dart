import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/views/my_run_ui.dart';
 
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});
 
  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}
 
class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyRunUI(),
        ),
      ),
    );
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/running.png',
              width: 250,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'การวิ่งของฉัน',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}