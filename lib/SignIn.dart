import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookmark.dart';
import 'SignUp.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  static String id = 'SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
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
                      alignment: Alignment.topCenter)),
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
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w900),
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
                                  gapPadding: 3.3),
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                          onChanged: (value) {
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
                                gapPadding: 3.3),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                        onChanged: (value) {
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
                            final user = await _auth.signInWithEmailAndPassword(
                                email: username, password: password);
                            if (user != null) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('email', username);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext ctx) => BookMark()));
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Wrong Cridentials! Pls Try again",
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
                            print(e);
                          }
                        },
                        child: Text(
                          'SIGN IN',
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
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SignUp.id);
                            },
                            child:
                            Text("Don't Have an Account? Register Now",
                            style: TextStyle(
                              fontSize: 15, 
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                        ))
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
