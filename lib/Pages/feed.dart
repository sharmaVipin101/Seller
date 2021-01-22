import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Functionalities/checkItem.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  FirebaseUser user;
  List<DocumentSnapshot> posts;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.blueGrey,
           appBar: AppBar(
        title: Text(
          'Seller',
          style: TextStyle(
            fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
        centerTitle: true,
      ),
        body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.
          collection('posts').orderBy("date", descending: true)
              .snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasData)
            {
              var doc = snapshot.data.documents;
              if(doc.length==0)
              {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Be the first user, start reselling",style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white70

                    )),
                  ),
                );
              }
              return ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (context,i){

                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context)=> CheckItem(doc[i].documentID)));
                          //checkItem(doc[i].documentID);
                        },
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.black38,
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
                                        text: "Item:",
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Colors.black
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${doc[i].data["caption"]}",
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FadeInImage(
                                  placeholder: AssetImage("assets/placeholder.jpg"),
                                  image: NetworkImage(doc[i].data["photoUrl"]),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    softWrap: true,
                                    text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        children: [

                                          TextSpan(
                                            text: "Actual Price: ₹",
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${doc[i].data["actualPrice"]}",
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

                                  Divider(height: 0,),
                                  RichText(
                                    softWrap: true,
                                    text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        children: [

                                          TextSpan(
                                            text: "Resell Price: ₹",
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${doc[i].data["resellPrice"]}",
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
                                  Divider(height: 0,)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
            }
            else return SpinKitFadingCube(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.black54 : Colors.black38,
                  ),
                );
              },
            );
          },
        ),

      );

  }
}

