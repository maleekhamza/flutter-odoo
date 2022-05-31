
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';

void main() {
  runApp(const MaterialApp(
    home: UploadInvoice(),
  ));
}

class UploadInvoice extends StatefulWidget {
  const UploadInvoice({Key key}) : super(key: key);

  @override
  State<UploadInvoice> createState() => _UploadInvoiceState();
}

class _UploadInvoiceState extends State<UploadInvoice> {
  
  File imageFile;
  String base64string ;

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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturing Images',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imageFile != null)
               Expanded(
                  child: ElevatedButton(
                 //convert Path to File
                  
                      onPressed: () async => await client.create("facture.model.activity",{"showImage":base64string}),
                      child: const Text('create', style: TextStyle(fontSize: 18,color: Colors.white,)),
                      style: ButtonStyle(
		backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 181, 41, 194))
	),
                  ),
                ),

            if(imageFile != null)
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 181, 41, 194),
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover
                  ),
                  border: Border.all(width: 8, color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
            else
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 8, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text('Image should appear here', style: TextStyle(fontSize: 26),),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()=> getImage(source: ImageSource.camera),
                      child: const Text('Captured', style: TextStyle(fontSize: 18,color: Colors.white)),
                   style: ButtonStyle(
		backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 181, 41, 194))
	),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()=> getImage(source: ImageSource.gallery),
                      child: const Text(' Gallery', style: TextStyle(fontSize: 18,color: Colors.white)),
                      style: ButtonStyle(
		backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 181, 41, 194))
	),
                  ),
                ),
                    
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void getImage({ ImageSource source}) async {
    
    final file = await ImagePicker.pickImage(
        source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70 //0 - 100
    );
    
    if(file?.path != null){
      setState(() {
        imageFile = File(file.path);
      });
    }
     imageFile = File(file.path);
     print(imageFile); 
              //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg
        Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
         base64string = base64.encode(imagebytes);
        print(base64string);

  }


}
