import 'package:flutter/material.dart';

import 'Sidebar/sidebar_layout.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white
      ),
      home: SideBarLayout(),
    );
      
  }
} 
  
