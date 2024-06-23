import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  SettingsPage({required this.isDarkMode, required this.toggleDarkMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profileImage;
  String _selectedLanguage = 'English';
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadSettings();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImage(_profileImage!);
    }
  }

  Future<void> _saveProfileImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = 'profile_image.png';
    final savedImage = await image.copy('$path/$fileName');

    setState(() {
      _profileImage = savedImage;
    });
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = 'profile_image.png';
    final filePath = '$path/$fileName';

    if (File(filePath).existsSync()) {
      setState(() {
        _profileImage = File(filePath);
      });
    }
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      _usernameController.text = prefs.getString('username') ?? 'Abdullah';
      _emailController.text = prefs.getString('email') ?? 'abdullah@example.com';
    });
  }

  Future<void> _changeLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = language;
    });
    await prefs.setString('selectedLanguage', language);
  }

  Future<void> _saveUsernameAndEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage("assets/image/abdullah.png") as ImageProvider,
                    radius: 40,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200, // Adjust the width as needed
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        onSubmitted: (_) => _saveUsernameAndEmail(),
                      ),
                    ),
                    SizedBox(
                      width: 200, // Adjust the width as needed
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        onSubmitted: (_) => _saveUsernameAndEmail(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                items: <String>['Arabic', 'Chinese', 'English', 'Bahasa Melayu']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _changeLanguage(newValue!);
                },
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dark Mode', style: TextStyle(fontSize: 18)),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (bool value) {
                    widget.toggleDarkMode(value);
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
    );
  }
}
