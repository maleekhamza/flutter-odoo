import 'dart:async';

import 'package:flutter/material.dart';

import 'login_page.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key key,this.title}) : super(key: key);


  final String title;

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool _isVisible = false;

  _GetStartedState(){

    new Timer(const Duration(milliseconds: 2000), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      });
    });

    new Timer(
      Duration(milliseconds: 100),(){
        setState(() {
          _isVisible = true; // Now it is showing fade effect and navigating to Login page
        });
      }
    );

  }

  @override
  Widget build(BuildContext context) {
   return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      
      child: AnimatedOpacity(
        opacity:  _isVisible ? 1.0:0 ,
        duration: Duration(milliseconds: 1200),
          child: Center(
          child: Container(
            height: 1000.0,
            width: 500,
           
             child: Center(
          child: Text(
          'INVOICE RECOGNITION',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold , color: Colors.white,decoration: TextDecoration.none),
            ),
          
          
          ),
          
          ),
                 
      ),
      
    )
    );
  }
}