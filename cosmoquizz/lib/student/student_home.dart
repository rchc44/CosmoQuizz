import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/authentication/auth.dart';
import '/main.dart';
import './student_profile/display_profile.dart';
import './student_quiz/display_quizzes.dart';
import './student_grades/display_grades.dart';

class StudentHome extends StatefulWidget {
  StudentHome({Key? key}) : super(key: key);
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  Color? _buttonColor;
  
  late User _currentUser;

  void verification() {
    if (_currentUser.emailVerified) {
      setState(() {
        _buttonColor = Colors.grey;
      });
    } else {
      setState(() {
        _buttonColor = Color.fromARGB(255, 33, 89, 243);
      });
    }
  }

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    verification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.home),
              SizedBox(width: 15),
              Text("Home", style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
        automaticallyImplyLeading: false,   // no default back arrow for going back to the previous page
        actions: [
          // profile button
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayProfile()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.assignment_ind),
                  SizedBox(width: 5),
                  Text(
                    "My Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromARGB(255, 33, 89, 243),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 40),
          // take quiz button
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayQuizzes()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.assignment),
                  SizedBox(width: 5),
                  Text(
                    "Take Quiz",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromARGB(255, 33, 89, 243),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 40),
          // view grades button
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayGrades()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.assignment_turned_in),
                  SizedBox(width: 5),
                  Text(
                    "View Grades",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromARGB(255, 33, 89, 243),
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 80),
          // sign out button
          _isSigningOut
            ? CircularProgressIndicator()
            : Center(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 5),
                      Text(
                        "Sign Out",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
          SizedBox(width: 60),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // set up logo
            Padding(
              padding: const EdgeInsets.only(right: 30.0, top: 90.0),
              child: Center(
                child: Container(
                  width: 500,
                  height: 400,
                  child: Image.asset('assets/logo/CosmoQuizz_transparent.png'),
                ),
              ),
            ),
            // welcome
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: RichText(
                text: TextSpan(
                  text: 'Welcome, student ',
                  style: TextStyle(fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${_currentUser.displayName}.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 33, 89, 243),
                      )
                    ),
                  ],
                ),
              )
            ),
            SizedBox(height: 30),
            // email verification status
            _currentUser.emailVerified
              // if already verified
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        'Email Verified',
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.sync),
                      onPressed: () async {
                        User? user = await Authentication.refreshUser(_currentUser);
                        if (user != null) {
                          setState(() {
                            _currentUser = user;
                          });
                        }
                      },
                    ),
                  ],
                )
              // if not verified
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Email Unverified',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      icon: Icon(Icons.sync),
                      onPressed: () async {
                        User? user = await Authentication.refreshUser(_currentUser);
                        if (user != null) {
                          setState(() {
                            _currentUser = user;
                          });
                        }
                      },
                    ),
                  ],
                ),
            SizedBox(height: 10),
            _isSendingVerification
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // verify email button
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_currentUser.emailVerified) {
                            print("You have already verified the email.");
                          }
                          else {
                            setState(() {
                              _isSendingVerification = true;
                            });
                            await _currentUser.sendEmailVerification();
                            setState(() {
                              _isSendingVerification = false;
                            });
                            // pop-up message
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) => sentVerification(context),
                            );
                          }
                        },
                        child: Text(
                          'Verify Email',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: _buttonColor,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

// pop-up message after clicked verify email button
Widget sentVerification(BuildContext context) {
  return AlertDialog(
    title: Text('Email Sent!', style: TextStyle(fontSize: 20)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "An email containing further instructions to verify email has been sent, please check your email inbox.",
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
    actions: <Widget>[
      // close button
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Close',
          style: TextStyle(
            color: Color.fromARGB(255, 33, 89, 243),
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}
