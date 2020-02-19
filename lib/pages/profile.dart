import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Home.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/services.dart';
//import 'package:email_validator/email_validator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter_multiselect/flutter_multiselect.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path/path.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget with NavigationStates {
  @override
  String userDoc;
  ProfilePage({this.userDoc});
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String docID;

  getDocId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      docID = prefs.getString('docID');
    });
  }

  String userDoc;
  _ProfilePageState({this.userDoc});

  bool _isSigningIn = false;
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  File _image;
  var dbRef = Firestore.instance;
  
  TextEditingController _nameController =TextEditingController();
  TextEditingController _numberController=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _specController=TextEditingController();
  TextEditingController _addressController=TextEditingController();

   var formkey = new GlobalKey<FormState>();

  @override
  void initState() {
    getDocId();

    super.initState();
  }

  @override

  // var firestore = Firestore.instance
  //       .collection('users')
  //       .where("userType", isEqualTo:"mechanic" && DocumentSnapshot, isEqualTo: )
  //       .getDocuments();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Profile',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'sans-serif-light',
                    color: Colors.black)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black,
                iconSize: 22.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ]),
        body: Container(
          color: Colors.white,
          child: ListView(children: <Widget>[
            StreamBuilder(
                stream: dbRef.collection('users').document(docID).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data == null || !(snapshot.data.exists)) {
                      print("printing user id");
                      print(userDoc);
                      print("printing data");
                      print(snapshot.data["address"]);
                    } else {
                      print("printing doc");
                      print(snapshot.data.data);
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 250.0,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  width: 140.0,
                                                  height: 140.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: ExactAssetImage(
                                                            'Images/perIcon.png'),
                                                        fit: BoxFit.cover),
                                                  )),
                                            ]),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0, right: 100.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                _getPhotoIcon()
                                              ],
                                            )),
                                      ]),
                                )
                              ],
                            ),
                          ),
                           Form(
                            key:formkey,
                            child:Column(children: <Widget>[
                              Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ])
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: _nameController,
                                              validator: (value) => value.isEmpty ? 'Nmae can\'t be Empty' : null,
                                               
        
       
                                              decoration: InputDecoration(
                                                hintText: snapshot
                                                    .data.data["name"]
                                                    .toString(),
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Email ID',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: _emailController,
                                              validator: (emailValue) => emailValue.isEmpty ? 'Email can\'t be Empty' : null,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                hintText: snapshot
                                                    .data.data["email"]
                                                    .toString(),
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,

                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Mobile Number',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: _numberController,
                                              maxLength: 10,
                                              validator: (numberValue) => numberValue.isEmpty ? 'mobile number can\'t be Empty' : null,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: InputDecoration(
                                                hintText: snapshot
                                                    .data.data["number"]
                                                    .toString(),
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Address',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: _addressController,
                                              validator: (addressValue) => addressValue.isEmpty ? ' address can\'t be Empty' : null,
                                              keyboardType:
                                                  TextInputType.text,
                                              decoration: InputDecoration(
                                                hintText: snapshot
                                                    .data.data["address"]
                                                    .toString(),
                                              ),
                                              enabled: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Special',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: _specController,
                                              
                                              decoration: InputDecoration(
                                                hintText: snapshot
                                                    .data.data["specification"]
                                                    .toString(),
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                             validator: (_specController) => _specController.isEmpty ? 'Special can\'t be Empty' : null,
      
                                            ),
                                          ),
                                        ],
                                      )),
                                  !_status
                                      ? _getActionButtons(context)
                                      : Container(),
                                ],
                              ),
                            ),
                          )


                            ],)
                            
                          )
                        ],
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ]),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                    //
                    if (formkey.currentState.validate()) {
                      String patttern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = new RegExp(patttern);
            if (!regExp.hasMatch(_emailController.text)) {
              Alert(
                context: context,
                title: "Email invalid!",
                desc: "Enter a valid Email Address!",
                type: AlertType.warning,
              ).show();
              setState(() {
                _status=false;
              });
              return;
            }
                    }

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("confirm"),
                          content: Text("Do you want to change"),
                          actions: [
                            FlatButton(
                              child: Text("yes"),
                              onPressed: () {
                                updateData(context);
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()),
                                );
                                setState(() {
                                  //initState();
                    
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                              },
                            ),
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()),
                                );
                              },
                            )
                          ],
                        );
                      });
                  setState(() {
                    initState();
                    _status = true;
                    // FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("confirm"),
                          content: Text("Do you want to leave change"),
                          actions: [
                            FlatButton(
                              child: Text("yes"),
                              onPressed: () {
                                

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()),
                                );

                                setState(() {
                                  //initState();
                                  _status = false;
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                });
                              },
                            ),
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()),
                                );
                              },
                            )
                          ],
                        );
                      });
                  setState(() {
                    _status = false;
                    //FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getPhotoIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 25.0,
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
      onTap: () {
        // setState(() {
        //   _status = false;
        //   _getPhoto();
        // }
        // );
        _getPhoto(ImageSource.gallery);
      },
    );
  }

  Future _getPhoto(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print("image path $_image");
    });
  }


 

     void updateData(BuildContext context) {
     
        dbRef
              .collection("users")
              .document(docID)
                      .updateData({
                    "name": _nameController.value.text,
                    
                    "email": _emailController.value.text,
                    
                    "number": _numberController.value.text,

                    "specification": _specController.value.text,
                    "address": _addressController.value.text,
            
      
    }
                      );}
  
}


