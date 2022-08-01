import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keijiban/firebase_options.dart';
import 'package:keijiban/home.dart';
import 'package:keijiban/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyKeijiban(title: 'keijiban'),
    );
  }
}

class MyKeijiban extends StatefulWidget {
  const MyKeijiban({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyKeijiban> createState() => _MyKeijibanState();
}

class _MyKeijibanState extends State<MyKeijiban> {

  bool _isSignedIn = false;
  String userId = '';

  void checkSignInState(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user == null) {
        setState(() {
          _isSignedIn = false;
        });
      } else {
        setState(() {
          userId = user.uid;
          _isSignedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //リスナーの実行を忘れないようにしましょう。
    checkSignInState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isSignedIn?Home(userId: userId):const SignUp(),
    );
  }
}
