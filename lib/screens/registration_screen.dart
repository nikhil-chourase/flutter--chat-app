import 'package:chat_app/components/roundedButton.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {

    static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;


  String? email;
  String? password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {

                email = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),

            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),

              onChanged: (value) {
                password = value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password') ,
            ),
            SizedBox(
              height: 24.0,
            ),

            RoundedButton(
              color: Colors.blueAccent,
              text: 'Register',
              onTap: () async{

                try{
                   final newUser = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);

                   if(newUser != null){
                     Navigator.pushNamed(context, ChatScreen.id);
                   }


                }catch(e){

                  print(e);

                }


              }
            ),
          ],
        ),
      ),
    );
  }
}