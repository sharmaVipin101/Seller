import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';



class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  File _image;
  bool loading = false;
  double uploadProgress =0;

  String _itemName;
  String _actualPrice;
  String _resellPrice;
  String _description;
  String _mobile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  pickFromCamera()async{
    var pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
//    setState(() {
//      _image = pickedFile;
//    });

  cropImage(pickedFile);



  }

  bool isDigit(String s)
  {
    return int.tryParse(s)!=null;
  }

  pickFromGallery()async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      _image = image;
//    });
    cropImage(image);

  }


  cropImage(File image)async{

    File croppedImage = await ImageCropper.cropImage(
        sourcePath:image.path,compressQuality: 40 );

    setState(() {
      _image = croppedImage;
    });

  }

  uploadImage()async{

    if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();
        try{
          if(_image!=null)
          {
            setState(() {
              loading = true;
              uploadProgress = 0;
            });

            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            String fileName = DateTime.now().millisecondsSinceEpoch.toString()+basename(_image.path);

            final StorageReference storageReference =
            FirebaseStorage.instance.ref().child('posts')
                .child(user.uid).child(fileName);

            final StorageUploadTask uploadTask = storageReference.putFile(_image);

            final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
              var totalBytes = event.snapshot.totalByteCount;
              var transferred = event.snapshot.bytesTransferred;

              double progress = ((transferred * 100) / totalBytes) / 100;
              setState(() {
                uploadProgress = progress;
              });
            });

            StorageTaskSnapshot onComplete = await uploadTask.onComplete;
            String photoUrl = await onComplete.ref.getDownloadURL();


            Firestore.instance.collection('posts')
                .add({
              "photoUrl": photoUrl,
              "name": user.displayName,
              "caption": _itemName,
              "actualPrice":_actualPrice,
              "resellPrice":_resellPrice,
              "date": DateTime.now().toString(),
              "uploadedBy": user.uid,
              "usermail":user.email,
              "description":_description,
              "mobile":_mobile

            });

            setState(() {
              loading = false;

            });

            streamSubscription.cancel();

            Navigator.of(this.context).pop();

          }
          else{
            showDialog(
                context: this.context,
                builder: (ctx) {
                  return AlertDialog(
                    content: Text("Please select image!"),
                    title: Text("Alert"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  );
                });
          }
        }catch(e){

        }
      }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Image"),
        actions: <Widget>[
          IconButton(
            tooltip: "Take from camera",
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              pickFromCamera();
            },
          ),
          IconButton(
            tooltip: "Select from phone",
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              pickFromGallery();
            },
          ),
        ],
      ),

//      _image != null
//          ? Image.file(_image)
//          : Image(
//        image: AssetImage("assets/placeholder.png"),
//      ),



      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),

                width: 330,
                height: 270,

                child: _image != null
            ? Image.file(_image)
              : Image(
          image: AssetImage("assets/placeholder.jpg"),
    ),
              ),

              loading
                  ? LinearProgressIndicator(
                value: uploadProgress,
                backgroundColor: Colors.grey,
              )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Form(

                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !loading,
                        validator: (input)
                        {
                          if(input.isEmpty)
                            {
                              return 'Fill it';
                            }

                        },
                        decoration: InputDecoration(
                          labelText: 'Item Name*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),

                          ),


                        ),
                        onSaved: (input){
                          _itemName = input;
                        },
                      ),

                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !loading,
                        validator: (input)
                        {
                          if(input.isEmpty)
                          {
                            return 'Fill it';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Item Description*',
                            errorMaxLines: 3,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),

                            )
                        ),
                        onSaved: (input){
                          _description = input;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !loading,
                        validator: (input)
                        {
                          if(input.isEmpty)
                          {
                            return 'Fill it';
                          }
                          if(!isDigit(input))
                            {
                              return 'Enter valid data';
                            }
                        },
                        decoration: InputDecoration(
                            labelText: 'Actual Price*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),

                            )
                        ),
                        onSaved: (input){
                          _actualPrice = input;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !loading,
                        validator: (input)
                        {
                          if(input.isEmpty)
                          {
                            return 'Fill it';
                          }
                          if(!isDigit(input))
                            {
                              return 'Enter valid data';
                            }


                        },
                        decoration: InputDecoration(
                            labelText: 'Resell Price*',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),

                            )
                        ),
                        onSaved: (input){
                          _resellPrice = input;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        enabled: !loading,
                        validator: (input)
                        {

                        },
                        decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),

                            )
                        ),
                        onSaved: (input){
                          _mobile = input;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: RaisedButton(
                        padding:
                        EdgeInsets.fromLTRB(120.0, 10.0, 120.0, 10.0),
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: uploadImage,
                        child: Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
