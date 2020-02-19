import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanic/pages/profile.dart';

import '../Sidebar/menu_item.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../Home.dart';
import '../main.dart'; // for published subject

class SideBar extends StatefulWidget {
  String userDoc;
  SideBar({this.userDoc});
  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar>

    with SingleTickerProviderStateMixin<SideBar> {
  String userDoc;
  SideBarState({this.userDoc});

  String docID;
  getDocId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      docID = prefs.getString('docID');
    });
  }

  AnimationController _animationController;
  //stream controller
  StreamController<bool> isSidebarOpenedStreamController;
  //async data event
  Stream<bool> isSideBarOpenedStream;
  //accepts stream events sync and async
  StreamSink<bool> isSidebarOpenedSink;

  final _animationDuration = const Duration(milliseconds: 500);

  var dbRef = Firestore.instance;

  @override
  void initState() {
    getDocId();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  //called when object is removed
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedStreamController.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status; //current status of the animation controller
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userDoc);
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              
              //to make the sidebar expanded
              StreamBuilder(
                stream: dbRef.collection('users').document(docID).snapshots(),
                builder: (context,snapshot){
                   if(snapshot.connectionState == ConnectionState.active)
                {
                  if(snapshot.data == null || !(snapshot.data.exists))
                    {
                      print("printing user id");
                      print(userDoc);
                      print("printing data");
                      print(snapshot.data["address"]);
                    }
                    else
                    {
                      print("printing doc");
                      print(snapshot.data.data);
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: const Color(0xFF262AAA),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          ListTile(
                            title: Text(
                              snapshot.data.data["Name"].toString() ,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              snapshot.data.data["email"].toString() ,
                              style: TextStyle(
                                color: Color(0xFF1BB5FD),
                                fontSize: 20,
                              ),
                            ),
                            leading: CircleAvatar(
                              child: Container(
                                  width: 145.0,
                                  height: 145.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            ExactAssetImage('Images/perIcon.png'),
                                        fit: BoxFit.cover),
                                  )),
                              //  Icon(
                              //    Icons.perm_identity,
                              //    color: Colors.white,

                              //  ),
                              radius: 30,
                            ),
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.home,
                            title: "Home",
                            onTap: () {
                              // Navigator.pop(context);
                              //  Navigator.push(
                              //    context,
                              //  MaterialPageRoute(
                              //   builder: (BuildContext context) => HomePage()));

                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.work,
                            title: "My works",
                            onTap: () {
                              // Navigator.pop(context);
                              //  Navigator.push(
                              //    context,
                              //  MaterialPageRoute(
                              //   builder: (BuildContext context) => MyWorksPage()));
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyWorksClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.time_to_leave,
                            title: "Non Emergency",
                            onTap: () {
                              //  Navigator.pop(context);
                              //   Navigator.push(
                              //    context,
                              //   MaterialPageRoute(
                              //    builder: (BuildContext context) => NonEmergencyPage()));
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.NonEmergencyClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.schedule,
                            title: "Schedule",
                            onTap: () {
                              // Navigator.pop(context);
                              //  Navigator.push(
                              //    context,
                              //  MaterialPageRoute(
                              //   builder: (BuildContext context) => SchedulePage()));
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.ScheduleClickedEvent);
                            },
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.settings,
                            title: "Profile",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProfilePage(userDoc: widget.userDoc)));
                              // onIconPressed();
                              //  BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ProfileClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.exit_to_app,
                            title: "Logout",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyHomePage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                }
                }),

              //to show the home page when the side bar is expanded
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  //to change the Shape of sidebar icon to curve
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 30,
                      height: 110,
                      color: Color(0XFF262AAA),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xFF1BB5FD),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 0, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
