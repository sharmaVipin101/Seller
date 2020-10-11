import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import '../Pages/homepage.dart';
import '../Pages/feed.dart';
import '../Pages/profile.dart';



class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data != null) {

            // if user is signed in
            return Bottom();

          } else {
            // if user is not signed in
            return Login();
          }
        }

        // if user is not signed in
        return Login();
      },
    );
  }
}


class Bottom extends StatefulWidget {
  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int pageIndex = 0;

  var pages = [Feed(),HomePage(),Profile()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Colors.white70,
        currentIndex: pageIndex,

        onTap: (i){
          setState(() {
            pageIndex = i;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(icon: Icon(Icons.local_offer), title: Text("Feed",style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),)),
          BottomNavigationBarItem(icon: Icon(Icons.photo), title: Text("HomePage",style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text("Profile",style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),)),

        ],
      ),
      body: pages[pageIndex],


    );
  }
}
