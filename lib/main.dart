import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'image.dart';
// import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp(app: app));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;
  MyApp({this.app});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Images(title: 'Flutter Demo Home Page', app: app),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.app}) : super(key: key);

  final String title;
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _ref;
  String url = "", name, contact;
  File imageFile;
  int index = 4;

  @override
  void initState() {
    final database = FirebaseDatabase(app: widget.app);
    _ref = database.reference();
    super.initState();
  }

  uploadData() async {
    try {
      await _ref
          .child(index.toString())
          .set({'name': name, 'contact': contact});
      setState(() {
        index = index + 1;
      });
      print('data upload success');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.grey[500],
                border: InputBorder.none,
                hintText: "Enter name",
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.grey[500],
                border: InputBorder.none,
                hintText: "Enter contact",
                labelText: 'Contact',
              ),
              onChanged: (value) {
                setState(() {
                  contact = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              child: Text('Send Data'),
              onPressed: () {
                print('$name , $contact');
                uploadData();
                print('upload');
              },
            ),
          ],
        ),
      ),
    );
  }
}
