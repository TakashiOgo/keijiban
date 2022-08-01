import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool alreadySignedUp = false;

  void handleSignUp()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text
      );
    }on FirebaseAuthException catch(e) {
      if(e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('すでに使用されているメールアドレスです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }else if(e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('パスワードが弱いです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }else if(e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('正しいメールアドレスを入力してください'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  void handleSignIn()async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text
      );
    }on FirebaseException catch(e) {
      if(e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('登録されていないアカウントです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }else if(e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('パスワードが違います'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }else if(e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('登録されていないメールアドレスです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailEditingController,
              decoration: const InputDecoration(labelText: 'メールアドレス', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20,),
            TextField(
              obscureText: true,
              controller: passwordEditingController,
              decoration: const InputDecoration(labelText: 'パスワード', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20,),
            alreadySignedUp?ElevatedButton(
                onPressed: (){
                  handleSignIn();
                },
                child: const Text('サインイン', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
              ),
            ):ElevatedButton(
                onPressed: () {
                  handleSignUp();
                },
                child: const Text('ユーザー登録', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                ),
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                setState((){
                  alreadySignedUp = !alreadySignedUp;
                  emailEditingController.clear();
                  passwordEditingController.clear();
                });
              },
              child: Text(
                alreadySignedUp?'新しいアカウントを作成':'すでにアカウントをお持ちですか？',
                style: const TextStyle(color: Colors.grey, decoration: TextDecoration.underline,),
              )
            )
          ],
        ),
      ),
    );
  }
}
