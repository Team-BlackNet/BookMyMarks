import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'SignIn.dart';
import 'bookmark.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool showSpinner = false;
  String name;
  String age;
  String gender;
  String country;
  String username;
  String password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
              width: MediaQuery.of(context).size.width,
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
                      child: Text('Register',
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
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                          onChanged: (value){
                            name = value;
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
                              labelText: 'Age',
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                          onChanged: (value){
                            age = value;
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
                              labelText: 'Gender',
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                          onChanged: (value){
                            gender = value;
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
                              labelText: 'Country',
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                          onChanged: (value){
                            country = value;
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
                              labelText: 'Username/Email',
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                          onChanged: (value){
                            username = value;
                          },
                        ),
                      ),
                    ),
                    Container(
                      // color: Color(0xfff5f5f5),
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                gapPadding: 3.3
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                        onChanged: (value){
                          password = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            AuthResult result = await _auth.createUserWithEmailAndPassword(
                                email: username, password: password);
                            if (result != null) {
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext ctx) => SignIn()));
                            }
                            await DatabaseService().updateUserData('0',
                                '0');

                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Invalid Username! Pls Try again",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          }
                          _firestore.collection('users').add({
                            'name': name,
                            'age': age,
                            'gender': gender,
                            'country': country,
                            'username': username,
                            'password': password,
                          });
                        },
                        child: Text('Register',
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
