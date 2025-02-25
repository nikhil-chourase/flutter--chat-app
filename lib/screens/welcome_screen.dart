import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/roundedButton.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration:  Duration(seconds: 3),
      vsync: this,
      );

      controller!.forward();   


      animation = ColorTween(begin:Colors.blueAccent,end: Colors.purpleAccent).animate(controller!);

      // animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

      // controller!.reverse(from: 1);


      // animation!.addStatusListener((status) { 
      //   if(status == AnimationStatus.completed){
      //     controller!.reverse(from: 1);
      //   }
      //   else if(status == AnimationStatus.dismissed){
      //     controller!.forward();
      //   }
      // });


      controller!.addListener(() {
        setState(() {   
          
        });
           print(controller!.value);
       });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash chat'], 
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent, 
              text: 'Log In', 
              onTap: (){
                Navigator.pushNamed(context, LoginScreen.id);

              }
             
            ),
            RoundedButton(
              text: 'Register',
              color: Colors.blueAccent,
              onTap: (){
                Navigator.pushNamed(context, RegistrationScreen.id);

            }, ),
          ],
        ),
      ),
    );
  }
}
