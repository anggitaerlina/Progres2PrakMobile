import 'dart:io';
import 'package:ecommerce_app/sign/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late String username;
  late SharedPreferences sharedPreferences;
  String _imagePath = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initial();
  }

  initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('username') ?? '';
    });
  }

  Future<void> _logout() async {
    await sharedPreferences.setBool('login', true);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImageFromCamera() async {
    final image = await getImage(true);
    if (image != null) {
      saveImageFile(image);
    }
  }

  Future<void> _getImageFromGallery() async {
    final image = await getImage(false);
    if (image != null) {
      saveImageFile(image);
    }
  }

  Future<String?> getImage(bool isCamera) async {
    final XFile? image;
    if (isCamera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }
    return image?.path;
  }

  Future<void> saveImageFile(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/profile_image.jpg');
    await file.writeAsBytes(await File(imagePath).readAsBytes());
    setState(() {
      _imagePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Anggita Erlina Aprilia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '124210034',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'May Vlawinzky Pelawi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '124210050',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Camera button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _getImageFromCamera();
                        },
                        icon: Icon(Icons.camera),
                        label: Text('Camera',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                          Size(double.infinity, 50), // Set button height
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Gallery button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _getImageFromGallery();
                        },
                        icon: Icon(Icons.image),
                        label: Text('Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                          Size(double.infinity, 50), // Set button height
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Logout button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _logout();
                        },
                        child: Text('Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                          Size(double.infinity, 50), // Set button height
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Display selected image
              _imagePath.isEmpty
                  ? Container()
                  : Image.file(File(_imagePath), height: 300, width: 300),
            ],
          ),
        ),
      ),
    );
  }
}
