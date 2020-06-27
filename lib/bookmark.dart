import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'viewbookmark.dart';

class DatabaseService {
  static String uid;
  final CollectionReference unitsCollection = Firestore.instance.collection(
      'bookmark').document(uid).collection('urlandatgs');

  Future updateUserData(String url,
      String tags) async {
    return await
    unitsCollection.add({
      'url': url,
      'tags': tags,
    });
  }
}

class BookMark extends StatefulWidget {
  static String id = 'BookMark';
  @override
  _BookMarkState createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  String uid;
  String url;
  String tags;
 
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        uid = user.uid;
      }
    } catch (e) {
      print(e);
    }
  }

 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Assets/image1.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.only(top: 270),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('BookMarks',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                gapPadding: 3.3
                            ),
                            labelText: 'Url',
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),                       
                        onChanged: (value){
                          url = value;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      //color: Color(0xfff5f5f5),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                gapPadding: 3.3
                            ),
                            labelText: 'Tags',
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                        onChanged: (value){
                          tags = value;
                        },
                      ),
                    ),
                  ),

                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          onPressed: () {
                            if(url!=null && tags!=null){
                              _firestore.collection('bookmark')
                                .document(uid)
                                .collection('urlandtags')
                                .add({
                              'url': url,
                              'tags': tags,
                            });
                            Fluttertoast.showToast(
                                msg: "Successfully Added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.pushNamed(context, BookMark.id);
                            }else{
                              Fluttertoast.showToast(
                                msg: "Url/Tags is/are null!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            }
                          },
                          child: Text('Add',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Color(0xffff2d55),
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, View.id);
                          },
                          child: Text('View',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Color(0xffff2d55),
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


