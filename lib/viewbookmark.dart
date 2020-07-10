import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url/bookmark.dart';
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
          uid = loggedInUser.uid;
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
        title: Text('BookMarks'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext ctx) => BookMark())),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: SafeArea(child: Stream(uid: uid)),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final tags = [
    'Delhi',
    'Mumbai',
    'Banglore',
    'Chandigarh',
    'Shimla',
    'Punjab',
    'Goa',
    'Pune',
    'Agra',
    'Bhatinda',
  ];

  final recenttags = [
    'Delhi',
    'Mumbai',
    'Banglore',
    'Chandigarh',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions fo app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recenttags
        : tags.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.bookmark),
        title: RichText(text: TextSpan(
          text: suggestionList[index].substring(0,query.length),
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: suggestionList[index].substring(query.length),
              style: TextStyle(color: Colors.grey)
            )
          ]
        ),),
      ),
      itemCount: suggestionList.length,
    );
    throw UnimplementedError();
  }
}

class Stream extends StatelessWidget {
  String url;
  final String uid;

  Stream({this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('bookmark/$uid/urlandtags').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
        final list = snapshot.data.documents;
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context1, index) {
              return ListTile(
                  title: Text(
                    list[index]['url'],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        backgroundColor: Colors.black),
                  ),
                  subtitle: Text(
                    list[index]['tags'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  onTap: () {
                    url = list[index]['url'];
                    //url.split()
                    if (url.substring(0, 7) == 'https://') {
                      launch(url);
                    } else {
                      url = 'https://' + list[index]['url'];
                      print(url);
                      launch(url);
                    }
                  },
                  onLongPress: () => Firestore.instance
                          .runTransaction((Transaction myTransaction) async {
                        await myTransaction
                            .delete(snapshot.data.documents[index].reference);
                      }));
            });
      },
    );
  }
}
