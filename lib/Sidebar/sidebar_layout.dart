import 'package:flutter/material.dart';
import 'package:mechanic/Sidebar/sidebar.dart';

import '../homepage.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children:<Widget>[
          HomePage(),
          SideBar(),
      ]
      ),
      
    );
  }
}