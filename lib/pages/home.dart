import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/pages/property_list.dart';
import 'package:flutter_real_estate/pages/rent_property.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_real_estate/pages/settings_page.dart';
import 'package:flutter_real_estate/theme/color.dart';
import 'package:flutter_real_estate/utils/data.dart';
import 'package:flutter_real_estate/widgets/category_item.dart';
import 'package:flutter_real_estate/widgets/custom_image.dart';
import 'package:flutter_real_estate/widgets/custom_textbox.dart';
import 'package:flutter_real_estate/widgets/icon_box.dart';
import 'package:flutter_real_estate/widgets/property_item.dart';
import 'package:flutter_real_estate/widgets/recent_item.dart';
import 'package:flutter_real_estate/widgets/recommend_item.dart';
import '../pages/login_page.dart';
import '../pages/settings_page.dart';
import '../pages/root.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _profileImage;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
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
    final fileName = 'assets/images/abdullah.png';
    final savedImage = await image.copy('$path/$fileName');

    setState(() {
      _profileImage = savedImage;
    });
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = 'assets/images/abdullah.png';
    final filePath = '$path/$fileName';

    if (File(filePath).existsSync()) {
      setState(() {
        _profileImage = File(filePath);
      });
    }
  }

  void _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = value;
    });
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appBgColor,
        title: _buildHeader(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 25)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage(isDarkMode: isDarkMode, toggleDarkMode: _toggleDarkMode)));// Navigate to settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Change Profile'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(); // Close the drawer
                // Navigate to change profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts_rounded),
              title: Text('Change to Seller'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PropertyList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts_rounded),
              title: Text('Rent Property'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RentPropertyPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage())); // Add logout functionality
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello!",
                  style: TextStyle(
                    color: AppColor.darker,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "\$name",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage("assets/image/abdullah.png") as ImageProvider,
                radius: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15,
          ),
          _buildSearch(),
          const SizedBox(
            height: 20,
          ),
          _buildCategories(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Popular",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildPopulars(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildRecommended(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildRecent(),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: CustomTextBox(
              hint: "Search",
              prefix: Icon(Icons.search, color: Colors.grey),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconBox(
            child: Icon(Icons.filter_list_rounded, color: Colors.white),
            bgColor: AppColor.secondary,
            radius: 10,
          )
        ],
      ),
    );
  }

  int _selectedCategory = 0;
  Widget _buildCategories() {
    List<Widget> lists = List.generate(
      categories.length,
          (index) => CategoryItem(
        data: categories[index],
        selected: index == _selectedCategory,
        onTap: () {
          setState(() {
            _selectedCategory = index;
          });
        },
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildPopulars() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 240,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .8,
      ),
      items: List.generate(
        populars.length,
            (index) => PropertyItem(
          data: populars[index],
        ),
      ),
    );
  }

  Widget _buildRecommended() {
    List<Widget> lists = List.generate(
      recommended.length,
          (index) => RecommendItem(
        data: recommended[index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildRecent() {
    List<Widget> lists = List.generate(
      recents.length,
          (index) => RecentItem(
        data: recents[index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }
}
