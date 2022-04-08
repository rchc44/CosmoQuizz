import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '/authentication/auth.dart';
import '/authentication/validator.dart';
import '/portal/login_portal.dart';
import './student_forgotpassword.dart';
import './student_signup.dart';
import './student_home.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final _loginFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  // go to home page if already sign in
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => StudentHome(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In', style: TextStyle(fontSize: 25)),
          automaticallyImplyLeading: false,   // no back arrow for going back to the previous page
          actions: [
            // return button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPortal()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.replay),
                    SizedBox(width: 5),
                    Text(
                      "Return to Portal Page",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromARGB(255, 33, 100, 243),
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          SizedBox(width: 60),
          ]
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Align(
                  alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // set up logo
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 60.0),
                          child: Center(
                            child: Container(
                              width: 500,
                              height: 400,
                              child: Image.asset('assets/logo/CosmoQuizz_transparent.png')
                            ),
                          ),
                        ),
                        Form(
                          key: _loginFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // email field
                                Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: Container(
                                    width: 600,
                                    child: TextFormField(
                                      controller: _emailTextController,
                                      focusNode: _focusEmail,
                                      validator: (value) => Validator.validateEmail(
                                        email: value,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                        labelText: 'Email',
                                        hintText: 'Enter Your Email',
                                        icon: Icon(
                                          Icons.mail,
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32.0),
                                          borderSide: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                // password field
                                Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: Container(
                                    width: 600,
                                    child: TextFormField(
                                      controller: _passwordTextController,
                                      focusNode: _focusPassword,
                                      validator: (value) => Validator.validatePassword(
                                        password: value,
                                      ),
                                      obscureText: true,  // hide entered password
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                        labelText: 'Password',
                                        hintText: "Enter Your Password",
                                        icon: Icon(
                                          Icons.lock,
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32.0),
                                          borderSide: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(color: Color.fromARGB(255, 33, 77, 243), fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _isProcessing
                                  ? CircularProgressIndicator()
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // sign in button
                                          Padding(
                                            padding: const EdgeInsets.only(right: 30.0),
                                            child: Container(
                                              height: 50,
                                              width: 250,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  _focusEmail.unfocus();
                                                  _focusPassword.unfocus();
                                                  if (_loginFormKey.currentState!.validate()) {
                                                    setState(() {
                                                      _isProcessing = true;
                                                    });
                                                    User? user = await Authentication.signIn(
                                                      email: _emailTextController.text,
                                                      password: _passwordTextController.text,
                                                    );
                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                    if (user != null) {
                                                      Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) => StudentHome(user: user),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Log In',
                                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(255, 33, 100, 243),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 50),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: TextButton(
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => StudentSignUp()),
                                                );
                                              },
                                              child: Text(
                                                'New User? Create Account!',
                                                style: TextStyle(color: Color.fromARGB(255, 33, 54, 243), fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                        )
                      ],
                    ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
