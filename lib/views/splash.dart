import 'package:checklist_master/views/topic_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  SplashWidgetState createState() => SplashWidgetState();
}

class SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    _getPreferences();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TopicList(),
          transitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child,);
          }
        ),
      );
    });
  }

  void _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('darkMode') == null){
      prefs.setInt('darkMode', 0);
    }
    if(prefs.getInt('weeks') == null){
      prefs.setInt('weeks', 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}