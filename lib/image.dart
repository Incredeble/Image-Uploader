import 'dart:io';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Images extends StatefulWidget {
  Images({Key key, this.title, this.app}) : super(key: key);

  final String title;
  final FirebaseApp app;

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  File imageFile;
  String url;

  Future getFromGallery() async {
    PickedFile file = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      imageFile = File(file.path);
    });
  }

  Future uploadPic() async {
    await Firebase.initializeApp();
    FirebaseStorage storage = FirebaseStorage.instance;
    final filename = basename(imageFile.path);
    Reference ref = storage.ref('images').child(filename);
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.then((res) {
      res.ref.getDownloadURL().then((firebaseUrl) {
        setState(() {
          url = firebaseUrl;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextButton(
                child: Text("PickImage"),
                onPressed: () {
                  getFromGallery();
                  print('file picked');
                },
              ),
            ),
            imageFile == null ? Text('Loading') : Image.file(imageFile),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                uploadPic();
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.teal, fontSize: 16.0),
              ),
            ),
            url == null ? Text("") : Image.network(url),
          ],
        ),
      ),
    );
  }
}
