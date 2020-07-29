
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialsite/models/User.dart';
import 'package:socialsite/pages/activity_feed.dart';
import 'file:///D:/flutter_projects/apps/social_site/lib/screens/create_account.dart';
import 'package:socialsite/pages/profile.dart';
import 'package:socialsite/pages/search.dart';
import 'package:socialsite/pages/upload.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection("users");
final postRef = Firestore.instance.collection("posts");
final StorageReference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // check for the authentication done
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleAuthChanges(account);
    },onError: (err){
      print("Error is: $err");
    });

    // sign in when user is already logged in
    googleSignIn.signInSilently(suppressErrors: false).then((account){
      handleAuthChanges(account);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  void handleAuthChanges(GoogleSignInAccount account){
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    }
    else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async{
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();
    if(!doc.exists){
      final username = await Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateAccount()));
      userRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio":"",
        "timestamp":timestamp,
      });
      doc = await userRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  login(){
    googleSignIn.signIn();
  }
  logOut(){
    googleSignIn.signOut();
  }
  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex){
    setState(() {
      pageController.animateToPage(
          pageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
    });
  }

  Scaffold unAuthWidget(BuildContext context){
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Theme.of(context).accentColor,Theme.of(context).primaryColorLight],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Connect Me',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48.0,
                  color: Colors.white,
                  fontFamily: "Signatra",
                  letterSpacing: 3.0,
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap:login,
                child: Container(
                  height: 60,
                  width: 260.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/google_signin_button.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  Widget authWidget(BuildContext context){
    return Scaffold(

      body: PageView(
        children: <Widget>[
//          Timeline(),
        RaisedButton(
          child: Text("logOUt"),
          onPressed: logOut,
        ),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 40.0),),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? authWidget(context): unAuthWidget(context);

  }
}
