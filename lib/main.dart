import 'package:firebase_now/authentication/register.dart';
import 'package:firebase_now/chats/chat.dart';
import 'package:flutter/material.dart';
import 'authentication/login1.dart';
import 'package:firebase_core/firebase_core.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  
  
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    //home: Login1Widget(),
    initialRoute: Login1Widget.id,
    routes: {
      ChatWidget.id:(context) => ChatWidget(),
      Login1Widget.id:(context)=>Login1Widget(),
      Register1Widget.id:(context)=>Register1Widget()
    },
    );
  }
}

