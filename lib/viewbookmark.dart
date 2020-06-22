import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class View extends StatefulWidget {
  static String id = 'View';
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  final _auth = FirebaseAuth.instance;
  String uid;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        uid=loggedInUser.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: null,
        title: Text('BookMarks'),
      ),
      body: SafeArea(
        child: Stream(uid: uid)
        ),
    );
  }
}

class Stream extends StatelessWidget {
  final String uid;
  Stream({this.uid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('bookmark/$uid/urlandtags').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } 
            final list = snapshot.data.documents;
            return ListView.builder(
              itemCount: list.length,
                itemBuilder: (context1, index){
                  return ListTile(
                    title: Text(list[index]['url'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      backgroundColor: Colors.black
                     ),
                    ),
                    subtitle: Text(list[index]['tags'],
                    style: TextStyle(
                      fontSize:16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                    ),
                  ),
                    onTap: () => launch(list[index]['url']),
                    onLongPress: () =>  Firestore.instance.runTransaction((Transaction myTransaction) async {
                      await myTransaction.delete(snapshot.data.documents[index].reference);
                      })
                  );
                }
            );
        },
      );
  }
}