import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:foodful/resources/firestore_methods.dart';
import 'package:foodful/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';
import '../models/user.dart';

import '../utils/colors.dart';

class commentScreen extends StatefulWidget {
  final snap;
  const commentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<commentScreen> createState() => _commentScreenState();
}

class _commentScreenState extends State<commentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message Board"),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => commentCard(
                      snap: (snapshot.data! as dynamic).docs[index].data(),
                    ));
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(user!.photoUrl),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 16),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Message as ${user.username}",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirestoreMethods().postComment(
                  widget.snap['postId'],
                  _commentController.text,
                  user.uid,
                  user.username,
                  user.photoUrl);

              setState(() {
                _commentController.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                "Send",
                style: TextStyle(color: lightpinkColor),
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
