import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keijiban/main.dart';


class Home extends StatefulWidget {
  const Home({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  TextEditingController postEditingController = TextEditingController();

  void addPost()async{
    await FirebaseFirestore.instance.collection('posts').add({
      'text': postEditingController.text,
      'date': DateTime.now().toString(),
      'user_id': widget.userId
    });
    postEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').orderBy('date').snapshots(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                List<DocumentSnapshot> postsData = snapshot.data!.docs;
                return Expanded(
                    child: ListView.builder(
                      itemCount: postsData.length,
                      itemBuilder: (context, index){
                        Map<String, dynamic> postData = postsData[index].data() as Map<String, dynamic>;
                        return postCard(postData);
                      }
                    ),
                );
              }
              return const Center(child: CircularProgressIndicator(),);
            }
          ),
          Container(
            height: 20,
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if(FirebaseAuth.instance.currentUser == null){
                  print('ログアウト');
                  }
                Navigator.of(context).push(MaterialPageRoute(builder: (context){return MyKeijiban(title: 'keijiban');}));
                },
              child: Text('ログアウト'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              children: [
                Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 3,
                      controller: postEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: (){addPost();},
                      icon: const Icon(Icons.send)
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postCard(Map<String, dynamic> postData){
    return Card(
      child: ListTile(
        tileColor: postData['user_id'] == widget.userId?Colors.orangeAccent:Colors.white,
        title: Text(postData['text']),
      ),
    );
  }
}
