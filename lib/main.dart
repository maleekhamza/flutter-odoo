import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

import 'pages/Get_Started.dart';

void main() {
  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {

  Color _primaryColor = HexColor('#DC54FE');
  Color _accentColor = HexColor('#8A02AE');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVOICE RECOGNITION',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: GetStarted(title: 'INVOICE RECOGNITION'),
    );
  }
}
