import 'package:flutter/material.dart';
import './UI/CustomInputField.dart';
import 'Home.dart';

class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,  //takes the width of the screen
        height: MediaQuery.of(context).size.height,
        color: Colors.orange,
        child: Center(
          child:Container(
            width:400,
            height:400,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                Material(
                  elevation: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('Images/logo.png', width:100, height:100),
                  
                  )
                  ),
                CustomInputField(
                  Icon(Icons.person, color: Colors.white), 'UserID'),
                CustomInputField(
                  Icon(Icons.lock, color: Colors.white), 'Password'),
                Container(
                  width: 100.0,
                  child: RaisedButton(onPressed:(){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  color: Colors.deepOrange, textColor: Colors.black,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text('Login', style: TextStyle(
                    fontSize: 20.0,
                  ),
                  ),
                  )
                  ),
              ]
            )
          )
        )

      )
      );
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
    
  }
}
