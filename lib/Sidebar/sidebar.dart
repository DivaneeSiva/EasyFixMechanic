import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Sidebar/menu_item.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:rxdart/rxdart.dart';// for published subject

class SideBar extends StatefulWidget {

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool>isSideBarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSideBarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose(){
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedStreamController.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
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
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        return AnimatedPositioned(
        duration: _animationDuration,
        top: 0,
        bottom: 0,
        left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
        right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
        child:Row(
        children: <Widget>[
            //to make the sidebar expanded 
            Expanded(
              child:Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: const Color(0xFF262AAA),
                 child: Column(
                   children: <Widget>[
                     SizedBox(height:100,),
                     ListTile(
                       title: Text("XXX", style:TextStyle(
                         color: Colors.white,
                         fontSize: 30, fontWeight: FontWeight.w800
                       ),
              
                       ),
                       subtitle: Text(
                         "xxx@gmail.com",
                         style: TextStyle(
                           color: Color(0xFF1BB5FD), fontSize: 20, 
                         ),
                       ),
                       leading: CircleAvatar(
                         child: Icon(
                           Icons.perm_identity,
                           color: Colors.white,
                           
                         ),
                         radius: 40,
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
                       onTap: (){
                         onIconPressed();
                         BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                       },
                     ),
                     MenuItem(
                       icon: Icons.work,
                       title: "My works",
                        onTap: (){
                         onIconPressed();
                         BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyWorksClickedEvent);
                       },
                     ),
                     MenuItem(
                       icon: Icons.schedule,
                       title: "Schedule",
                        onTap: (){
                         onIconPressed();
                         BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ScheduleClickedEvent);
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
                       title: "Settings",
                     ),
                     MenuItem(
                       icon: Icons.exit_to_app,
                       title: "Logout",
                     ),

                   ],

                 ),
              ),
            ),
        
            //to show the home page when the side bar is expanded
          Align(
            alignment: Alignment(0, -0.9),
            child:GestureDetector(
              onTap: (){
                onIconPressed();
              },
              //to change the Shape of sidebar icon to curve
              child: ClipPath(
                clipper: CustomMenuClipper(),
                  child: Container(
                  width:35,
                  height: 110,
                  color:Color(0XFF262AAA),
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

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width= size.width;
    final height= size.height; 


    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1,height/2-20, width, height/2);
    path.quadraticBezierTo(width, height/2+20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    
    return true;
  }

}