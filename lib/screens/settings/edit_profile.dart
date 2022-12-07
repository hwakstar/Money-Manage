import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_manager/screens/home/home_drawer.dart';
import 'package:money_manager/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, this.isFromInit = false}) : super(key: key);
  final bool isFromInit;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late SharedPreferences prefs;
  final nameController = TextEditingController();
  final storageBox = Hive.box('storage');
  File? imageFile;
  String imageString = '';
  bool imageChanged = false;
  @override
  void initState() {
    super.initState();
    _readSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFromInit ? 'Set Profile' : 'Profile'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Semantics(
                      label: 'Choose image',
                      child: GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.transparent,
                            backgroundImage: Util.getAvatharImage(imageString)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -15,
                      child: Material(
                        color: Colors.blue,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              _pickImage();
                            },
                            icon: const Icon(Icons.camera_alt)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                autofocus: false,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(8),
                    counter: Text('')),
              ),
              const SizedBox(height: 15)
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          _save();
                        },
                        child: Text(
                          widget.isFromInit ? 'Next' : 'Save',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _pickImage() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            height: 170,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile photo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelIconButton(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onPress: () {
                          Navigator.pop(context);
                          _choosePhoto(ImageSource.camera);
                        }),
                    LabelIconButton(
                        icon: Icons.image,
                        label: 'Gallery',
                        onPress: () {
                          Navigator.pop(context);
                          _choosePhoto(ImageSource.gallery);
                        }),
                    LabelIconButton(
                        icon: Icons.delete,
                        label: 'Remove \n Photo',
                        iconColor: Colors.red,
                        onPress: () {
                          _removeImage();
                          Navigator.pop(context);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  _readSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = storageBox.get('userName', defaultValue: '');
      imageString = storageBox.get('profilePhoto', defaultValue: '');
    });
  }

  _choosePhoto(source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 500);

    if (image == null) return;
    imageFile = File(image.path);
    setState(() {
      imageString = Util.imageToString(imageFile);
    });
  }

  _removeImage() async {
    setState(() {
      imageString = '';
    });
    storageBox.delete('profilePhoto');
  }

  _save() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please provide a name',
        ),
        behavior: SnackBarBehavior.fixed,
        duration: Duration(milliseconds: 700),
      ));
      return;
    }
    storageBox.put('userName', nameController.text);
    storageBox.put('profilePhoto', imageString);
    if (widget.isFromInit) {
      prefs.setBool('isInited', true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeDrawer()));
    } else {
      Navigator.pop(context);
    }
  }
}

class LabelIconButton extends StatelessWidget {
  const LabelIconButton({
    Key? key,
    this.iconColor = Colors.blue,
    required this.icon,
    required this.label,
    required this.onPress,
  }) : super(key: key);
  final IconData icon;
  final Color iconColor;
  final String label;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 80,
        height: 100,
        child: TextButton(
          onPressed: () {
            onPress();
          },
          style: TextButton.styleFrom(
            primary: iconColor.withOpacity(0.1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
