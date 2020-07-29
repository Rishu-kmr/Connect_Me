import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialsite/models/User.dart';
import 'package:socialsite/screens/home.dart';
import 'package:socialsite/widgets/header.dart';
import 'package:socialsite/widgets/post.dart';
import 'package:socialsite/widgets/progress.dart';
import 'edit_profile.dart';
class Profile extends StatefulWidget {

  final String profileId;
  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts;

  getProfilePosts() async{
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot =  await postRef.document(widget.profileId).collection('userPosts').orderBy('timestamp',descending: true).getDocuments();
    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
      print('${posts} empty');
    });
  }

  editProfile(){
    // dynamically create a route by material page route
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
      EditProfile(currentUserId: currentUserId)));
  }

  buildButton({String text, Function function}){
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: editProfile,
        child: Container(
          width: 200.0,
          height: 26.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton(){
    // viewing your own profile - should show profile button
    bool isProfileOwner = currentUserId==widget.profileId;
    if(isProfileOwner){
      return buildButton(
        text:"Edit Profile",
        function: editProfile,
      );
    }
  }

  Column buildCountColumn(String label, int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  buildHeaderProfile(){
    return FutureBuilder(
      future: userRef.document(widget.profileId).get(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    radius: 40.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts",postCount),
                            buildCountColumn("followers",0),
                            buildCountColumn("following",0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  user.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.bio,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  List<String> fruits = ['mango','ad;sf','apple','banana','grape','mango','ad;sf','apple','banana','grape','mango','ad;sf','apple','banana','grape','mango','ad;sf','apple','banana','grape'];

  buildProfilePosts(){
    if(isLoading) {
      return CircularProgress();
    }
    print('${posts} empty in build');
    return
      Column(
        children: posts,
    );
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getProfilePosts();
  }
  buildNoPosts(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300.0,
      child: Center(
        child: Text(
          'No Posts',
          style: TextStyle(
            fontSize: 60.0,
            fontFamily: 'Signatra',
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,appTitle: "profile"),
      body: ListView(
        children: <Widget>[
          buildHeaderProfile(),
          Divider(
            height: 0.0,
          ),
//          buildProfilePosts(),
        buildNoPosts(),
        ],
      ),
    );
  }
}
