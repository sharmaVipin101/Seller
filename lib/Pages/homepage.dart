import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String name;
  String photoUrl;
  bool isLoaded = false;
  var myposts;
  FirebaseUser user;


  Widget appBarTitle = new Text(
    "Search Item",

    style: new TextStyle(color: Colors.white70,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),
  );

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();

  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  HomePageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }



  void getData() async{

    try{
      FirebaseUser user = await FirebaseAuth.instance.currentUser();


      QuerySnapshot posts = await Firestore.instance
          .collection('posts')
          .getDocuments();


      setState(() {
        isLoaded = true;
        this.user = user;
        myposts = posts.documents;

      });

    }catch(e){

    }

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSearching = false;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        key: globalKey,
        appBar: buildAppBar(context),
      body: isLoaded==true ? (
          searchresult.length != 0 || _controller.text.isNotEmpty ? new GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1.0
              ),
              itemCount: searchresult.length,
            itemBuilder: (context,i)=>SizedBox(
//            width: 100,
//            height: 50,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0)
                  ),
                  child: Image(
                      image: NetworkImage(myposts[i].data["photoUrl"])==null ? AssetImage("assets/placeholder.jpg") : NetworkImage(myposts[i].data["photoUrl"]),
                      fit: BoxFit.cover
                  ),
                  onPressed: (){

                  }),
            ),)
              : GridView.builder(

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0
            ),itemCount: myposts.length,

            itemBuilder: (context,i)=>SizedBox(
//            width: 100,
//            height: 50,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0)
                  ),
                  child: Image(
                      image: NetworkImage(myposts[i].data["photoUrl"])==null ? AssetImage("assets/placeholder.jpg") : NetworkImage(myposts[i].data["photoUrl"]),
                      fit: BoxFit.cover
                  ),
                  onPressed: (){

                  }),
            ),
          )
      )
          : SpinKitFadingCube(
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

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontFamily: 'Quicksand')),
                cursorColor: Colors.white70,
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Sample",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < myposts.length; i++) {
        String data = myposts[i].data['caption'];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }


}
