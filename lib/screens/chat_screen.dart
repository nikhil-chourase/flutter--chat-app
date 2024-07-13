import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

final _firetore = FirebaseFirestore.instance;

late User loggedInUser;



class ChatScreen extends StatefulWidget {

  
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final messageTextController = TextEditingController();


  final _auth = FirebaseAuth.instance;


  String usernamne='';

  String? messageText;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  

  void getCurrentUser() async{

    try{
      final user = await _auth.currentUser;
      loggedInUser = user!;

      usernamne = loggedInUser.email.toString();

      print(loggedInUser.email);


    }catch(e){

    }
  }


  void getMessages() async{

    final messages = await _firetore.collection('messages').get();

    for (var message in messages.docs){
      print(message.data());
    }
  }


  void messagesStream() async{

    await for(var snapshot in _firetore.collection('messages').snapshots()){

      for (var message in snapshot.docs){
        print(message.data());
      }
    }

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {

                messagesStream();

                // getMessages();
                // _auth.signOut();
                // Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            StreamMessages(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,

                      onChanged: (value) async {

                        messageText = value;

                     
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {

                      messageTextController.clear();




                        _firetore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser!.email,
                        });
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
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


class StreamMessages extends StatelessWidget {
  const StreamMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              stream: _firetore.collection('messages').snapshots(),
               builder: (context, snapshot) {
                  List<MessageBubble> messageBubbles = [];


                  if(snapshot.hasData){
                    final messages = snapshot.data?.docs.reversed;


                    for(var message in messages!){
                      final messageText = message.get('text');
                      final sender = message.get('sender');

                      final currentUser = loggedInUser.email;

                      if(sender == currentUser){
                        // message sent by logged in person

                      }
                      

                      final messages = MessageBubble(text: messageText, sender: sender, isMe: sender == currentUser,);

                      messageBubbles.add(messages);

                    }

                   
                  }
                   return Expanded(
                     child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                        children: messageBubbles,
                      ),
                   );


               }
               
            );
  }
}



class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.sender, required this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [

          Text(sender),
          Material(
            
            borderRadius: isMe?  BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ):  BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ) ,
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text
                                
                                  ,style: TextStyle(
                                    fontSize: 20,
                                    color: isMe? Colors.white :Colors.black ,
                                  ),),
            ),
          ),
        ],
      ),
    );;
  }
}