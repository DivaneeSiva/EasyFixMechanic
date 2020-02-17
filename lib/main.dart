import 'package:flutter/material.dart';
import 'package:mechanic/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _showPassword = false;
  String _email;
  String _password;

  var formkey = new GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final phoneField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      style: style,
      controller: _emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (value) => value.isEmpty ? 'Email can\'t be Empty' : null,
      onChanged: (val) {
        setState(() {
          _email = val;
        });
      },
    );

    final passwordField = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: !_showPassword,
      style: style,
      controller: _passwordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password ",
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
      validator: (value) => value.isEmpty ? 'Password can\'t be Empty' : null,
      onChanged: (val) {
        setState(() {
          _password = val;
        });
      },
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

          print(_emailController.text.toString());
          var userDoc = await Firestore.instance
              .collection("users")
              .where("email", isEqualTo: _emailController.text.trim())
              .getDocuments();

          print(userDoc.documents.toString());

          if (formkey.currentState.validate()) {
            if (userDoc.documents.length > 0) {
              if (userDoc.documents.first.data['userType'] != "mechanic") {
                Alert(
                  context: context,
                  title: "Invalid",
                  desc: "Invalid Email Or password",
                  type: AlertType.error,
                ).show();
                setState(() {
                  _isSigningIn = false;
                  _emailController.clear();
                  _passwordController.clear();
                });
                return;
              } else {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                if (_email != null && _password != null) {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((res) {
                    FirebaseAuth.instance.currentUser().then((user) {
                      FirebaseAuth.instance.currentUser().then((user) {
                        Firestore.instance
                            .collection("users")
                            .where("email", isEqualTo: user.email)
                            .getDocuments()
                            .then((qs) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      userDoc: qs.documents.first.documentID)));
                                                        prefs.setString('docID', qs.documents.first.documentID);

                        });
                      });
                    });
                  }).catchError((error) {
                    Alert(
                      context: context,
                      title: "Not found",
                      desc: "Get registerd",
                      type: AlertType.error,
                    ).show();
                    _emailController.clear();
                    _passwordController.clear();
                  });
                } else {}
              }
            } else {
              Alert(
                context: context,
                title: "Not found!",
                desc: "Please register",
                type: AlertType.error,
              ).show();
              setState(() {
                _isSigningIn = false;
                 _emailController.clear();
                 _passwordController.clear();
              });
              return;
            }
          } 
            
          
        },
        child: Text(
          "Log in",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 100, 30, 10),
          color: Colors.white,
          child: Form(
            key: formkey,
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  _isSigningIn ? LinearProgressIndicator() : SizedBox.shrink(),
                  Image.asset(
                    "Images/logo.png",
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 45.0),
                  phoneField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(height: 35.0),
                  loginButon,
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
