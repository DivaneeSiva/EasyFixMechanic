import 'package:flutter/material.dart';
import 'Login.dart';
//import 'Home.dart';


void main(){ 
  runApp(MyApp()
  
   );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'EasyFix',
     home: Login(), 
    );
  }
}

