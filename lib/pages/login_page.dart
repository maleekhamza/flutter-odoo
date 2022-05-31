import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:flutter_odoopfe/pages/profile_page.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import '../common/theme_helper.dart';
import 'widgets/header_widget.dart';

var client = new OdooClient("http://10.0.2.2:8069");

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String database;
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 181, 41, 194)),
                      ),
                      Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  decoration: (ThemeHelper()
                                      .textInputDecoration('Database',
                                          'Enter your database name')),
                                  onChanged: (value) {
                                    this.database = value;
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  decoration: (ThemeHelper()
                                      .textInputDecoration(
                                          'Email', 'Enter your Email')),
                                  onChanged: (value) {
                                    this.email = value;
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  decoration: (ThemeHelper()
                                      .textInputDecoration(
                                          'Password', 'Enter your Password')),
                                  onChanged: (value) {
                                    this.password = value;
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        'Sign In'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      client
                                          .authenticate(
                                              email, password, database)
                                          .then((auth) {
                                        if (auth.isSuccess) {
                                          final user = auth.getUser();
                                          name = user.name;
                                          print("Hello ${user.name}");
                                          //After successful login we will redirect to profile page. Let's create profile page now
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                        name: name,
                                                        database: database,
                                                        email: email,
                                                      )));
                                        } else {
                                          print("Login Gagal");
                                        }
                                      });
                                    },
                                  )),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
