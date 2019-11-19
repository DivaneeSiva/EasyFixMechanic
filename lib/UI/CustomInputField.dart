import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget{
   
   Icon fieldIcon;
   String hintText;


  CustomInputField(this.fieldIcon, this.hintText);

  @override
  Widget build(BuildContext context) {
    
    return Container(
                  width:250.0,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.deepOrange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: fieldIcon,
                        ),
                        Container(
                          decoration: BoxDecoration(
                             color: Colors.white, 
                             borderRadius: BorderRadius.only(topRight:Radius.circular(10.0),
                             bottomRight: Radius.circular(10.0))
                             ),
                          
                          width:200.0,
                          height: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                             decoration: InputDecoration(
                              border:InputBorder.none,
                              hintText: hintText,
                             fillColor: Colors.white,
                             filled: true,
                            ),
                      style: TextStyle(
                       fontSize: 20.0,
                       color: Colors.black,
                      ),
                            ),
                          ),
                        )

                      ]
                    )
                  )
                 );
  }

}

class CustomListTile extends StatelessWidget{

  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0 ,0 ,8.0,0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade700))
        ),
        child: InkWell(
          
          splashColor: Colors.orangeAccent,
          onTap: () => {},
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                children: <Widget>[
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text, style: TextStyle(
                    fontSize: 16.0

                  )
                  ),
                  ),
                  ],

                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }


}