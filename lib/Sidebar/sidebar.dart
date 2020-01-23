import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
          //to make the sidebar expanded 
          Expanded(
            child:Container(
              color: Color(0xFF262AAA),
            )
          ),
          //to show the home page when the side bar is expanded
          Container(
            width:35,
            height: 110,
          )
      ],
    );

  
  }
}