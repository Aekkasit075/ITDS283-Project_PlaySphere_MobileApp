import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // เพิ่มการนำเข้า dart:io
import 'dart:convert';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'SearchPage.dart';
import 'MyCartPage.dart';
import '../login_screen.dart';
import 'futures/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config.dart';

class MyProfilePage extends StatefulWidget {
  final UserModel user;

  MyProfilePage({required this.user});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 3;
  late TabController _tabController;
  bool isLoading = true;
  late UserModel user;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: selectedIndex,
    );
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    _loadImage();
  }

  Future<void> _loadImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateUserProfile({
    required String email,
    String? newEmail,
    String? newUsername,
    String? newPassword,
    File? profilePictureFile,
  }) async {
    setState(() => isLoading = true);
    final uri = Uri.parse('${AppConfig.baseUrl}/update_user');
    final request = http.MultipartRequest('POST', uri);

    // เพิ่มฟิลด์ต่างๆ ลงใน request
    request.fields['email'] = email;
    if (newEmail != null) request.fields['new_email'] = newEmail;
    if (newUsername != null) request.fields['new_username'] = newUsername;
    if (newPassword != null) request.fields['new_password'] = newPassword;

    // แนบไฟล์รูปภาพ
    if (profilePictureFile != null) {
      print('Uploading file: ${profilePictureFile.path}');
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profilePictureFile.path,
        ),
      );
    }

    // ส่งคำขอ
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        print('Profile updated successfully: $jsonResponse');

        if (jsonResponse['profile_picture'] != null) {
          setState(() {
            user = user.copyWith(
              profilePicture: jsonResponse['profile_picture'],
            );
            _image = null;
          });
        }
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }


  Future<int> _getDownloadedAppCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedGames =
        prefs.getStringList('downloaded_games') ?? [];
    return downloadedGames.length;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
      await updateUserProfile(
        email: user.email,
        profilePictureFile: File(pickedFile.path),
      );
    }
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("แก้ไข $title"),
          content: TextField(
            controller: controller,
            obscureText: title == "รหัสผ่าน",
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ยกเลิก"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToTab(int index) {
    setState(() {
      selectedIndex = index;
    });
    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = HomePage(user: user);
        break;
      case 1:
        targetPage = ManageApp(user: user);
        break;
      case 2:
        targetPage = SearchPage(user: user);
        break;
      case 3:
        targetPage = MyProfilePage(user: user);
        break;
      case 4:
        targetPage = MyCartPage(user: user);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF205568),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/PlaySphere_Logo.png', height: 80.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToTab(3),
                  child: Row(
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5.w),
                      CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            widget.user.profilePicture != 'default.png'
                                ? NetworkImage(
                                  '${AppConfig.baseUrl}/uploads/${widget.user.profilePicture}',
                                )
                                : null,
                        child:
                            widget.user.profilePicture == 'default.png'
                                ? Icon(Icons.account_circle, color: Colors.grey)
                                : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          onTap: _navigateToTab,
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.settings), text: "ManageApp"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.person), text: "MyProfile"),
            Tab(icon: Icon(Icons.shopping_cart), text: "MyCart"),
          ],
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "บัญชี",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                _image != null
                                    ? FileImage(File(_image!.path))
                                    : (user.profilePicture != "default.png"
                                        ? NetworkImage(
                                          '${AppConfig.baseUrl}/uploads/${user.profilePicture}',
                                        )
                                        : null),
                            child:
                                (_image == null &&
                                        user.profilePicture == "default.png")
                                    ? Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 60.h,
                                    )
                                    : null,
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text(
                            'แสดงข้อมูลบัญชี',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text("ข้อมูลอีเมลบัญชี"),
                          subtitle: Text(user.email),
                          trailing: Icon(Icons.edit),
                          onTap:
                              () => _editField(
                                "อีเมล",
                                user.email,
                                (value) => setState(
                                  () => user = user.copyWith(email: value),
                                ),
                              ),
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text("ข้อมูลชื่อบัญชี"),
                          subtitle: Text(user.username),
                          trailing: Icon(Icons.edit),
                          onTap:
                              () => _editField(
                                "ชื่อบัญชี",
                                user.username,
                                (value) => setState(
                                  () => user = user.copyWith(username: value),
                                ),
                              ),
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text("ข้อมูลรหัสบัญชี"),
                          subtitle: Text("******"),
                          trailing: Icon(Icons.edit),
                          onTap:
                              () => _editField(
                                "รหัสผ่าน",
                                user.password,
                                (value) => setState(
                                  () => user = user.copyWith(password: value),
                                ),
                              ),
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text(
                            'แสดงข้อมูลเกี่ยวกับแอป',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(color: Colors.grey),
                        FutureBuilder<int>(
                          future: _getDownloadedAppCount(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: Text("จำนวนแอปที่เคยโหลด:"),
                                subtitle: Text("กำลังโหลด..."),
                              );
                            }
                            return ListTile(
                              title: Text("จำนวนแอปที่เคยโหลด:"),
                              subtitle: Text(snapshot.data.toString()),
                            );
                          },
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text(
                            "ออกจากระบบ",
                            style: TextStyle(color: Colors.red),
                          ),
                          trailing: Icon(Icons.exit_to_app),
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}