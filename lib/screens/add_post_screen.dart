import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodful/Providers/user_provider.dart';
import 'package:foodful/models/user.dart';
import 'package:foodful/resources/firestore_methods.dart';
import 'package:foodful/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../widgets/location_input.dart';

class addPost extends StatefulWidget {
  const addPost({Key? key}) : super(key: key);

  @override
  State<addPost> createState() => _addPostState();
}

// void selectImage() async {
//     Uint8List im = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = im;
//     });
//   }

class _addPostState extends State<addPost> {
  bool isLoading = false;
  Uint8List? file;
  bool isVeg = false;
  bool isEvent = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  double lat = 0;
  double lng = 0;

  void postImage(
    String uid,
    String username,
    String profilePic,
    double latitude,
    double longitude,
    bool isVeg,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _titleController.text,
        _quantityController.text,
        file!,
        uid,
        username,
        profilePic,
        latitude,
        longitude,
        isVeg,
        isEvent,
      );
      setState(() {
        isLoading = false;
      });
      if (res == "Post Uploaded") {
        Navigator.pop(context);
        showSnackBar(context, "Posted Successfully");
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void _selectPlace(double lat, double lng) {
    this.lat = lat;
    this.lng = lng;
  }

  Future _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text('Photo with Camera'),
              onPressed: () async {
                Uint8List file = await pickImage(ImageSource.camera)
                    .whenComplete(() => Navigator.of(context).pop());
                setState(() {
                  this.file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: lightpinkColor,
          actions: [
            TextButton(
                onPressed: () => postImage(
                      user!.uid,
                      user.username,
                      user.photoUrl,
                      lat,
                      lng,
                      isVeg,
                    ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ))
          ],
        ),
        body: Column(
          children: [
            isLoading
                ? LinearProgressIndicator(
                    color: pinkColor,
                    backgroundColor: lightpinkColor,
                  )
                : const Padding(padding: EdgeInsets.only(top: 0)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(children: [
                  file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(file!),
                          backgroundColor: Colors.white,
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              Image.asset('assets/abstract.jpeg').image,
                          backgroundColor: Colors.white,
                        ),
                  Positioned(
                    bottom: -14,
                    left: 60,
                    child: IconButton(
                      onPressed: () {
                        _selectImage(context);
                      },
                      icon: const Icon(Icons.add_a_photo_rounded),
                      color: pinkColor,
                    ),
                  ),
                ]),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Food Item',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: lightpinkColor,
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: lightpinkColor,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Quantity',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: lightpinkColor,
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Event: ", style: const TextStyle(fontSize: 18)),
                Switch(
                    value: isEvent,
                    onChanged: (value) {
                      setState(() {
                        isEvent = !isEvent;
                      });
                    }),
                Text("Veg: ", style: const TextStyle(fontSize: 18)),
                Switch(
                    value: isVeg,
                    onChanged: (value) {
                      setState(() {
                        isVeg = !isVeg;
                      });
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: LocationInput(_selectPlace),
            ),
          ],
        ));
  }
}
