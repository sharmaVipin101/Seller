import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CheckItem extends StatefulWidget {

  final docId;
  CheckItem(this.docId);
  @override
  _CheckItemState createState() => _CheckItemState(docId);
}

class _CheckItemState extends State<CheckItem> {

  String docid;
  _CheckItemState(this.docid);

  String actualprice;
  String resellprice;
  String date;
  String name;
  String photo;
  String caption;
  bool loading = true;
  String email ;
  String description;
  String mobile;

  void getData()async{

  DocumentSnapshot doc = await Firestore.instance.collection('posts').document(docid).get();

  setState(() {
    actualprice = doc['actualPrice'];
    caption = doc['caption'];
    resellprice = doc['resellPrice'];
    date = doc['date'];
    name = doc['name'];
    photo = doc['photoUrl'];
    email = doc['usermail'];
    description = doc['description'];

    if(doc['mobile']==null)
      {
        mobile = 'Not available';
      }
   else mobile = doc['mobile'];

    loading = false;
  });


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  callAction(String number) async{


    String url = 'tel:$number';
    if(await canLaunch(url))
    {
      await launch(url);
    }else {
      throw 'Could not call $number';
    }
  }
  emailAction(String email) async{
    String url = 'mailto:$email';
    if(await canLaunch(url))
    {
      await launch(url);
    }else {
      throw 'Could not message $email';
    }
  }
  smsAction(String number) async{
    String url = 'sms:$number';
    if(await canLaunch(url))
    {
      await launch(url);
    }else {
      throw 'Could not message $number';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          'Seller',
          style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: loading==true ? SpinKitFadingCube(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.black54 : Colors.black38,
              ),
            );
          },
        ) : SingleChildScrollView(
        child:Container(

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Color(0x22000000),
                  offset: Offset(0,4),
                ),
              ]
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[

              RichText(
                softWrap: true,
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [

                      TextSpan(
                        text: "Seller Name:",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      TextSpan(
                        text: "${name.substring(0,1).toUpperCase()}${name.substring(1,name.length)}",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,

                          color: Colors.deepOrange,
                        ),
                      ),


                    ]
                ),
              ),
              SizedBox(height: 5,),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage(
                  placeholder: AssetImage("assets/placeholder.jpg"),
                  image: NetworkImage(photo),
                ),
              ),
              Divider(height: 5,),
              RichText(
                softWrap: true,
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [

                      TextSpan(
                        text: "Description:",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text: "${description}",
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),


                    ]
                ),
              ),
              Divider(height: 5,),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    softWrap: true,
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [

                          TextSpan(
                            text: "Actual Price:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                              color: Colors.black,
                              fontSize: 15,

                            ),
                          ),
                          TextSpan(
                            text: "${actualprice}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                              color: Colors.deepOrange,
                            ),
                          ),


                        ]
                    ),
                  ),
                  Divider(height: 5,),
                  RichText(
                    softWrap: true,
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [

                          TextSpan(
                            text: "Resell Price:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                              color: Colors.black,
                              fontSize: 15,

                            ),
                          ),
                          TextSpan(
                            text: "${resellprice}",
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,

                              color: Colors.deepOrange,
                            ),
                          ),


                        ]
                    ),
                  ),

                ],
              ),
              Card(
                color: Colors.white,
                elevation: 3.0,
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          splashColor: Colors.green,
                          iconSize: 30.0,
                          icon: Icon(Icons.phone),
                          color: Colors.green,
                          onPressed: () {
                              callAction(mobile);
                          },

                        ),
                        IconButton(
                          splashColor: Colors.blue,
                          iconSize: 30.0,
                          icon: Icon(Icons.email),
                          color: Colors.blue,
                          onPressed: () {
                            emailAction(email);
                          },
                        ),
                        IconButton(
                          splashColor: Colors.orange,
                          iconSize: 30.0,
                          icon: Icon(Icons.message),
                          color: Colors.orange,
                          onPressed: () {
                            smsAction(mobile);
                          },

                        ),
                      ],
                    )),
              ),

            ],
          ),
        ),
      ),
    );
  }
}