import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../bloc.navigation_bloc/navigation_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'map.dart';
import '../Home.dart';

String dddsn;

class MyHomePage extends StatelessWidget with NavigationStates {
  String userDoc;
  MyHomePage({ this.userDoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text(
          'Notifications',
        ),

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
              .collection("mechanic_request")
              .where("machenic", isEqualTo: widget.userDoc)
              .getDocuments(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              if (!snapshot.hasData)
                return Container(
                  child: Text("no data"),
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
            title: Text(ds.data["name"] + ds.data["state"].toString()),
            onTap: () => navigateToDetail(ds));
      case 1:
        return ListTile(
            title: Text(ds.data["Current_Phone"] + ds.data["state"].toString()),
            onTap: () => navigateToDetail(ds));
      case 2:
        return Container();
        // return ListTile(title: Text(ds.data["name"] + ds.data["state"].toString()));
      default:
        return Center(
        child:Container( 
        child: Text("No requests!", 
        style:TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        
      ),
      color: Colors.blue[100],
      alignment:Alignment.center,
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
  bool _state= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  Container(
          //          padding: EdgeInsets.only(left: 25.0),

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
                          title: Text(widget.post.data["Vehicle_Type"]),
                          subtitle: Text(widget.post.data["vehicle_Number"]),
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
                                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPage()),
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
                                  widget.post.reference
                                      .updateData({"state": 2});
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );

                                  // setState(() {
                                  //   _status = true;
                                  //   FocusScope.of(context).requestFocus(new FocusNode());
                                  // });
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
                )
                )
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
          .updateData({'state':""});
    } catch (e) {
      print(e.toString());
    }
  }
}
