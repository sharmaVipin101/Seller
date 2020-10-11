import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Pages/aboutme.dart';

class Login extends StatelessWidget {
  String userid;

  void doGoogleSignIn(context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      userid = user.email;
      //print("signed in " + user.displayName);


      if(handleuser(context)) {
        // store user data
        Firestore.instance
            .collection("users")
            .document(user.uid)
            .setData({
          "email": user.email,
          "displayName": user.displayName,
          "photoUrl": user.photoUrl,
          "lastLogin": DateTime.now().toString()
        });
      }else FirebaseAuth.instance.signOut();


    } catch (e) {
      print(e);
    }
  }

  bool handleuser(context){
    int userEmailLength = userid.length;

    int UniversityId = userEmailLength-15;
    //vipin1142.cse18@chitkara.edu.in
//
//    if(userid.substring(UniversityId,userid.length)=='chitkara.edu.in')
//      {
//
//          Navigator.push(context, new MaterialPageRoute(
//              builder:(context)=> HomePage()
//          ));
//
//      }else
    if(userid.substring(UniversityId,userid.length)!='chitkara.edu.in')  {
      showDialog(
          context:context,
        builder: (BuildContext context){
            return AlertDialog(
              title: Text(
                'Invalid User',
              ),
              content: Text(
                'Use Chitkara Id'
              ),
              actions: [
                FlatButton(
                  child: Text('Exit'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Ok'
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },

                )
              ],
            );
        }
      );
      return false;
    }return true;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/books2.jpg'),
                  colorFilter: ColorFilter.mode(Colors.redAccent,
                      BlendMode.luminosity
                  ),
                  fit: BoxFit.cover,
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoogleSignInButton(
                  onPressed: () {
                    doGoogleSignIn(context);
                  },
                  // default: false
                ),
                GestureDetector(
                  child: Text(
                    'About Developer',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontFamily: 'Times New Roman'
                    ),

                  ),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder:(context)=> AboutMe()
                    ));
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}


