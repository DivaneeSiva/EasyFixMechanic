//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
import '../bloc.navigation_bloc/navigation_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Home.dart';

String dddsn;

class NonEmergencyPage extends StatelessWidget with NavigationStates {
  String userDoc;
  NonEmergencyPage({@required this.userDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Non Emergency Requests',
          ),
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
          ]
          //style:TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
          ),
      body: ListPage(userDoc),
    );
  }
}

class ListPage extends StatefulWidget {
  String userDoc;
  ListPage(this.userDoc);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userDoc);
    return Container(
      child: FutureBuilder(
          future: Firestore.instance
              .collection("NonEmergency_Request")
              .where("mechanic", isEqualTo: widget.userDoc)
              .getDocuments(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              if (!snapshot.hasData)
                return Container(
                  child: Text("no requests yet!"),
                );
              else {
                return ListView(
                  children: snapshot.data.documents
                      .map((doc) => mapDocToListTile(doc))
                      .toList(),
                );
              }
            }
          }),
    );
  }

  Widget mapDocToListTile(DocumentSnapshot ds) {
    switch (ds.data["state"]) {
      case 0:
        return ListTile(
            title: Text(
              ds.data["Cname"], //+ ds.data[''].toString(),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            onTap: () => navigateToDetail(ds));
      case 1:
        return ListTile(
            title: Text(
              ds.data["CNumber"], //+ ds.data["state"].toString(),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            onTap: () => navigateToDetail(ds));
      case 2:
        return Container();
      // return ListTile(title: Text(ds.data["name"] + ds.data["state"].toString()));
      default:
        return Center(
          child: Container(
            child: Text(
              "No requests yet!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            color: Colors.blue[100],
            alignment: Alignment.center,
            width: 200,
            height: 100,
          ),
        );
    }
  }
}

class DetailPage extends StatefulWidget with NavigationStates {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _State createState() => _State();
}

class _State extends State<DetailPage> {
  var firestore = Firestore.instance;
  bool _state = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  Container(
          //          padding: EdgeInsets.only(left: 25.0),
          centerTitle: true,
          title: Text('Requests',
              textAlign: TextAlign.left,
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
      // actions: <Widget>[ IconButton(
      //   icon: Icon(Icons.arrow_back_ios),
      //   color: Colors.black,
      //   iconSize: 22.0,
      //   onPressed:(){
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context)=>HomePage()),

      body: Container(
        color: Colors.blue,
        child: ListView(children: <Widget>[
          Column(children: <Widget>[
            Container(
                height: 250.0,
                color: Colors.indigo[900],
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )),
                    Container(
                      child: Center(
                        child: Card(
                            child: ListTile(
                          title: Text(widget.post.data["Vehicle"]),
                          subtitle: Text(widget.post.data["date"]),
                        )),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                  child: new RaisedButton(
                                child: new Text("Accept"),
                                textColor: Colors.white,
                                color: Colors.green,
                                onPressed: () {
                                  widget.post.reference
                                      .updateData({"state": 1});
                                      SnackBar mySnack = SnackBar(content: Text("Accepted"));
                                                Scaffold.of(context).showSnackBar(mySnack);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Container(
                                  child: new RaisedButton(
                                child: new Text("Reject"),
                                textColor: Colors.white,
                                color: Colors.red,
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => HomePage()),
                                  // );

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("confirm"),
                                          content:
                                              Text("Do you want to reject"),
                                          actions: [
                                            FlatButton(
                                              child: Text("yes"),
                                              onPressed: () {
                                                widget.post.reference
                                                    .updateData({"state": 2});
                                                    SnackBar mySnack = SnackBar(content: Text("Rejected"));
                                                Scaffold.of(context).showSnackBar(mySnack);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()),
                                                );
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("No"),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage()),
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              )),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    )
                  ],
                ))
          ]),
        ]),
      ),
    );
  }

  void updateData(BuildContext context) {
    try {
      firestore
          .collection('mechanic_request')
          .document(widget.post.documentID)
          .updateData({'state': ""});
    } catch (e) {
      print(e.toString());
    }
  }
}
