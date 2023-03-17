import 'package:flutter/material.dart';
import 'package:foodful/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class commentCard extends StatefulWidget {
  final snap;
  const commentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<commentCard> createState() => _commentCardState();
}

class _commentCardState extends State<commentCard> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilePic']),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                            text: widget.snap['text'],
                            style: const TextStyle(color: Colors.black)),
                      ]))
                    ]),
              ),
            ),
          ],
        ));
  }
}
