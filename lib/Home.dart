import 'package:flutter/material.dart';
import './UI/CustomInputField.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Profile.dart';
import 'Payment.dart';
import 'Settings.dart';
import 'Works.dart';

 class HomePage extends StatefulWidget {
   @override
   _HomePageState createState() => _HomePageState();
 }
 
 class _HomePageState extends State<HomePage> {
    GoogleMapController myController;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Column(
         children: <Widget>[
           Container(
            height: 500.0,
            width: double.infinity,
            child: GoogleMap(
              
              
              // options: GoogleMapOptions(
              //   cameraPosition: CameraPosition(
              //     target: 
              //   )
              onMapCreated:(controller){
                setState(() {
                  myController = controller;
                });

              },
              
              )
            ),
            

         ],
         )
       
     );
   }
 }



 class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('EasyFix'),
        backgroundColor:Colors.deepOrange,

      ) ,
       
     drawer: Drawer(
       child: ListView(
         children: <Widget>[
           DrawerHeader(
             decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Colors.deepOrange,
                Colors.orangeAccent
              ]
              ) 
             ),
             child: Container(
               child:Column(
                 children: <Widget>[
                  
                   Icon(Icons.person),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('Hi!', style:TextStyle(color: Colors.white, fontSize: 20.0),),
                   )
                 ],
               ) ,
             )
             ),
           CustomListTile(Icons.person, 'Profile', ()=>{
             Navigator.push(context,MaterialPageRoute(builder: (context) => Profile()))}),
           CustomListTile(Icons.payment, 'Payment', ()=>{
             Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()))}),
           CustomListTile(Icons.pan_tool, 'Works', ()=>{
            Navigator.push(context, MaterialPageRoute(builder: (context) => Works()))}),
           CustomListTile(Icons.settings, 'Settings', ()=>{
             Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()))}),
         ],
       ),
     ),
      
    );
  }
}

