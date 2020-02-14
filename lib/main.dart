import 'package:flutter/material.dart';
import 'Home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
      MyHomePage({Key key, this.title}) : super(key: key);
      
      final String title;
      @override
      _MyHomePageState createState() => _MyHomePageState();
    }


class _MyHomePageState extends State<MyHomePage> {
      TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
      TextEditingController _editingController1 = TextEditingController();
      TextEditingController _editingController2 = TextEditingController();
      bool _isSigningIn = false; 
       bool _showPassword = false;

      @override
      Widget build(BuildContext context) {

        final mobileField = TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          style: style,
          controller: _editingController1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Mobile number",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

        //  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        //   RegExp regExp = new RegExp(pattern);
        //   if (!regExp.hasMatch(_phoneNumber.text)) {
        //     Alert(
        //       context: context,
        //       title: "Phone number invalid!",
        //       desc: "Enter a valid phone number!",
        //       type: AlertType.warning,
        //     ).show();
        //     setState(() {
        //       _isSigningIn = false;
        //     });
        //     return null;
        //   }
        //    var userDoc = await Firestore.instance
        //       .collection("Customers")
        //       .document(_phoneNumber.text)
        //       .get();

        //   if (userDoc.exists) {
        //     Alert(
        //       context: context,
        //       title: "User exits",
        //       desc: "A user already exist for this phone number! try again !!",
        //       type: AlertType.error,
        //     ).show();
        //     setState(() {
        //       _isSigningIn = false;
        //     });
        //     return null ;
        //   }

        final passwordField = TextField(
          obscureText: !_showPassword,
          style: style,
          controller: _editingController2,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
              )),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );

        final loginButon = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
              setState(() {
            _isSigningIn = true;
          });
          var userDoc = await Firestore.instance
              .collection("mechanic")
              .document(_editingController1.text)
              .get();

          if (userDoc.exists) {
            if (userDoc.data['password'] != _editingController2.text) {
              Alert(
                context: context,
                title: "Password doesn't match!",
                desc: "",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
              });
              return;
            } else {

              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>HomePage()),
              );
            }
            } else {
            Alert(
              context: context,
              title: "You are not registered!",
              desc: "please register!",
              type: AlertType.error,
            ).show();
            setState(() {
              _isSigningIn = false;
            });
            return;
          }
            },

            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(
                     // height: 155.0,
                      // child: Image.asset(
                      //   "assets/logo.png",
                      //   fit: BoxFit.contain,
                      // ),
                      Logo(),
                    //),
                    SizedBox(height: 45.0),
                    mobileField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      
      }
      
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('Images/logo.png');
    Image image = Image(image: assetImage);
    return Container(child: image,);
  }
  
}

