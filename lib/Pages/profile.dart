import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functionalities/upload.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String name;
  String photoUrl;
  bool isLoaded = false;
  var myPosts;
  FirebaseUser user;

  int itemsSold = 0;
  String _itemName;
  String _actualPrice;
  String _resellPrice;
  String _description;
  String _phone;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{

    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DocumentSnapshot doc = await Firestore.instance.collection('users').document(user.uid).get();

      QuerySnapshot posts = await Firestore.instance
          .collection('posts').where('uploadedBy',isEqualTo: user.uid)
          .getDocuments();


      setState(() {
        isLoaded = true;
        this.user = user;
         myPosts = posts.documents;
        name = doc.data['displayName'];
        photoUrl = doc.data['photoUrl'];
      });

    }catch(e){

    }

  }

void deleteDialog(String id,int i)
{
  showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: Text(
        'Delete Post'
      ),
      content: Text(
        'Are you sure ?'
      ),
      actions: [
        FlatButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,

            ),

          ),
          onPressed: (){
             Firestore.instance.collection('posts').document(id).delete();
             Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
              'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,

            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  });
}

void soldDialog(String id,int i)
{
  showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: Text(
          'Item Sold'
      ),
      content: Text(
          'YAY seriously !!!'
      ),
      actions: [
        FlatButton(
          child: Text(
            'Yes, delete it ',
            style: TextStyle(
              fontWeight: FontWeight.bold,

            ),

          ),
          onPressed: (){
            // Firestore.instance.collection('uniqueposts').document(user.uid).collection('userposts').document(myPosts[i].documentID).delete();
            setState(() {
              itemsSold++;
            });
          },
        ),
        FlatButton(
          child: Text(
            'No, not now',
            style: TextStyle(
              fontWeight: FontWeight.bold,

            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  });
}

void update(String id) async
{

  if(_formKey.currentState.validate()) {
    _formKey.currentState.save();


    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance.collection('posts').document(id)
        .updateData({'actualPrice': this._actualPrice, 'resellPrice': this._resellPrice, 'caption': this._itemName,'description':this._description,'mobile':this._phone});

    Navigator.of(context).pop();
  }
}


bool isDigit(String s)
{
  return int.tryParse(s)!=null;
}


void updateSpecificPost(String id)
{
  showDialog(context:context,
  builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),

        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (input)
                    {
                      if(input.isEmpty)
                      {
                        return 'Fill it';
                      }

                    },
                    decoration: InputDecoration(
                      labelText: 'Item Name',
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
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (input)
                    {
                      if(input.isEmpty)
                      {
                        return 'Fill it';
                      }

                    },
                    decoration: InputDecoration(
                      labelText: 'Item Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),

                      ),


                    ),
                    onSaved: (input){
                      _description = input;
                    },
                  ),

                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (input)
                    {
                      if(input.isEmpty && !isDigit(input))
                      {
                        return 'Fill it';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Actual Price',
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
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (input)
                    {
                      if(input.isEmpty && !isDigit(input))
                      {
                        return 'Fill it';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Resell Price',
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
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (input)
                    {

                    },
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),

                      ),


                    ),
                    onSaved: (input){
                      _phone = input;
                    },
                  ),

                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0,left: 10,right: 10),
                  child: RaisedButton(
                    //padding:EdgeInsets.fromLTRB(120.0, 10.0, 120.0, 10.0),
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    onPressed: () {

                      update(id);

                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  });
}
  void specificUserPost(String id,int i)
  {
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Container(
          height: 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
         child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image:NetworkImage(myPosts[i].data["photoUrl"]) //
                  ,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Divider(
                height: 20.0,
              ),
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
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text: "${myPosts[i].data["actualPrice"]}",
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
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text: "${myPosts[i].data["resellPrice"]}",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.blueGrey,
                    child: Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        fontSize: 17

                      ),

                    ),
                    onPressed:(){
                      Navigator.of(context).pop();
                    } ,
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
                    child: Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        fontSize: 17
                      ),

                    ),
                    onPressed:(){
                      updateSpecificPost(id);
                    } ,
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  RaisedButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        fontSize: 17
                      ),

                    ),
                    color: Colors.red,
                    onLongPress:(){
                      deleteDialog(id,i);

                    } ,
                  ),
                  RaisedButton(
                    child: Text(
                      'Sold',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        fontSize: 17,
                      ),

                    ),
                    color: Colors.blueGrey,
                    onPressed:(){
                      soldDialog(id,i);
                      //Firestore.instance.collection('uniqueposts').document(user.uid).collection('userposts').document(myPosts[i].documentID).delete();
                    } ,
                  ),
                ],
              )
            ],

          ),
        ),

      );
    });
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
                fontWeight: FontWeight.bold,
                fontSize: 30
            ),
          ),
          centerTitle: true,
        ),
        body: isLoaded==true ? Container(

          child: Center(
            child: Column(
              children: [
//                Center(
                  //child:
                  Container(
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    child: ClipRRect(

                      borderRadius: BorderRadius.circular(170),
                      child: Image(
                        image:NetworkImage(photoUrl) //
                        ,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                //),
                SizedBox(height: 20,),
                Text(
                  name.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                        ,color: Colors.white70
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [

                    RaisedButton(

                      onLongPress: (){
                        FirebaseAuth.instance.signOut();
                      },

                        child: Text("LOGOUT",style: TextStyle(fontFamily: 'Quicksand',fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Upload(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Text("UPLOAD",style: TextStyle(fontFamily: 'Quicksand',fontSize: 20,fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
                Divider(height: 10,),
                myPosts.length==0 ? Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("If you upload anything in-appropriate then ONLY you will be responsible (degree pr sign pta h na kiske hone h)",style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.orange

                    ) ,),
                    Text("Come on start reselling.",style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white70

                    ) ,),
                    Text("Tip: use long press to delete and log out.",style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white70

                    ) ,),
                  ],

                )
                    :Expanded(
                    child: GridView.builder(
                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.0,
                        crossAxisCount: 3,
                        mainAxisSpacing: 0.2,
                        crossAxisSpacing: 0.2,
                      ),
                      itemCount: myPosts.length,
                      itemBuilder: (context,i){
                        return Card(
                          child: GestureDetector(
                            onTap: (){
                              specificUserPost(myPosts[i].documentID,i);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.0),
                              child: Image(
                                image:NetworkImage(myPosts[i].data["photoUrl"]) //
                                ,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        );
                      },
                    ),

                )

              ],
            ),
          ),
        ) :  SpinKitFadingCube(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.black54 : Colors.black38,
              ),
            );
          },
        )
      );

  }
}

