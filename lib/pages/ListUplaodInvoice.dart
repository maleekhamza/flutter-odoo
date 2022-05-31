import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'image.dart';


import 'UploadInvoice.dart';
import 'login_page.dart';




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({ this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var count = 10;
  bool check = true;
  List listdata = [];
  List data = [];
  var imageView;
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController searchButtonController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  var client = OdooClient("http://10.0.2.2:8069");
  Future<List> _getOrders() async {
    final domain = [];
    var fields = ["name_seq2", "last_date"];
    AuthenticateCallback auth = await client.authenticate(
        "base", "maleek29@gmail.com", "base");
    if (auth.isSuccess) {
      final user = auth.getUser();
      print("Hey ${user.username}");
    } else {
      print("Login failed");
    }
    OdooResponse result =
        await client.searchRead("facture.model.activity", domain, fields);
    if (!result.hasError()) {
      print("Successful");
      setState(() {
        check = false;
        var response = result.getResult();
        data = response['records'];
        listdata = data;
        print("CCC");
        print(listdata);
        print(listdata.length);
      });
    } else {
      print(result.getError());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none),
              hintText: "Search..",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              suffixIcon: Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            maxLines: 1,
            controller: searchButtonController,
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  listdata = data
                      .where((u) => (u['name_seq2']
                              .toString()
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u['last_date']
                              .toString()
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
              )
          ),
        ),
         
        ),
            drawer: Drawer(
        child: Container(
          decoration:BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).accentColor.withOpacity(0.5),
                  ]
              )
          ) ,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [ Theme.of(context).primaryColor,Theme.of(context).accentColor,],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text("INVOICE RECOGNITION",
                    style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ), 
              ListTile(
                leading: Icon(Icons.archive_outlined , color: Theme.of(context).accentColor),
                title: Text('Upload your invoice',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadInvoice()),);
                },
              ), 
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.account_circle_outlined , color: Theme.of(context).accentColor,),
                title: Text('List of uploaded invoices',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
                },
              ),
                Divider(color: Theme.of(context).primaryColor, height: 1,),
                   ListTile(
                leading: Icon(Icons.logout_rounded, color: Theme.of(context).accentColor,),
                title: Text('Logout',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                },
              ),
            ],
          ),
        ),
      ),
        body: check
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listdata.length == 0
                ? Center(
                    child: Text("No Data Found"),
                  )
                : Container(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listdata.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            margin: EdgeInsets.all(4),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                 
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      listdata[index]['name_seq2'].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                 
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.access_alarm),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          listdata[index]['last_date']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),     
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ));
  }
  Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}
}