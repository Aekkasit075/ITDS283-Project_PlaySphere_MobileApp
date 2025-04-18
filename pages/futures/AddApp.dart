import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../HomePage.dart';
import '../SearchPage.dart';
import '../MyProfilePage.dart';
import '../MyCartPage.dart';
import '../ManageApp.dart';
import '../../config.dart';
import 'user_model.dart';

class AddPage extends StatefulWidget {
  final UserModel user;

  AddPage({required this.user});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  int selectedIndex = 1;
  int sideMenuIndex = 5;
  late TabController _tabController;
  bool isLoading = true;

  File? _bannerImage;
  File? _screenshotImage;
  File? _gameProfileImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _downloadsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  Future<void> _submitGame() async {
    final url = Uri.parse("${AppConfig.baseUrl}/add_game");

    var request = http.MultipartRequest('POST', url);

    // เพิ่มข้อมูลที่ต้องการส่งไป
    request.fields['game_name'] = _nameController.text;
    request.fields['size'] = _sizeController.text;
    request.fields['price'] = _priceController.text;
    request.fields['total_downloads'] = _downloadsController.text;
    request.fields['description'] = _descriptionController.text;

    // ถ้ามีการเลือกไฟล์รูป ให้ส่งไปด้วย
    if (_bannerImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('banner_image', _bannerImage!.path),
      );
    }

    if (_screenshotImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'screenshot_image',
          _screenshotImage!.path,
        ),
      );
    }

    if (_gameProfileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'game_profile',
          _gameProfileImage!.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      _showSuccessDialog();
    } else {
      _showFailureDialog();
    }
  }

  // ฟังก์ชันแสดง dialog สำเร็จ
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("เพิ่มสำเร็จ"),
            ],
          ),
          content: Text("แอปของคุณได้ถูกเพิ่มเรียบร้อยแล้ว"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog สำเร็จ
                // ไปที่หน้า ManageApp
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageApp(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("ตกลง", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันแสดง dialog การเพิ่มไม่สำเร็จ
  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("เพิ่มไม่สำเร็จ"),
            ],
          ),
          content: Text("การเพิ่มแอปของคุณล้มเหลว กรุณาลองใหม่อีกครั้ง"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog ล้มเหลว
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("ตกลง", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(String type) async {
    File? imageFile;

    if (Platform.isAndroid || Platform.isIOS) {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    } else {
      // สำหรับ Desktop: Windows / macOS / Linux
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        imageFile = File(result.files.single.path!);
      }
    }

    if (imageFile != null) {
      setState(() {
        if (type == 'banner') {
          _bannerImage = imageFile;
        } else if (type == 'screenshot') {
          _screenshotImage = imageFile;
        } else if (type == 'game_profile') {
          _gameProfileImage = imageFile;
        }
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate based on the selected tab (For the main tabs)
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: widget.user)),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManageApp(user: widget.user)),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage(user: widget.user)),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyProfilePage(user: widget.user),
        ),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyCartPage(user: widget.user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF205568),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/PlaySphere_Logo.png', height: 80.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to MyProfilePage when tapped
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfilePage(user: widget.user),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text("Account", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 5.w),
                      Icon(Icons.account_circle, color: Colors.white),
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
          onTap: _onTabSelected,
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
              : Row(
                children: [
                  Container(
                    width: 50.w,
                    color: const Color(0xFF796F6F),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sideMenuIndex = 1;
                            });
                            _onTabSelected(1);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            color:
                                sideMenuIndex == 1
                                    ? const Color(0xFF878383)
                                    : const Color(0xFF796F6F),
                            child: Column(
                              children: [
                                Icon(Icons.apps, color: Colors.white),
                                Text(
                                  "app",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sideMenuIndex = 5;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddPage(user: widget.user),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            color:
                                sideMenuIndex == 5
                                    ? const Color(0xFF878383)
                                    : const Color(0xFF796F6F),
                            child: Column(
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                Text(
                                  "add",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Text(
                              "Added Game",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap:
                                                () =>
                                                    _pickImage('game_profile'),
                                            child: Container(
                                              height: 80.h,
                                              width: 80.h,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image:
                                                    _gameProfileImage != null
                                                        ? DecorationImage(
                                                          image: FileImage(
                                                            _gameProfileImage!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                        : null,
                                              ),
                                              child:
                                                  _gameProfileImage == null
                                                      ? Icon(
                                                        Icons.image,
                                                        size: 40,
                                                        color: Colors.white,
                                                      )
                                                      : null,
                                            ),
                                          ),

                                          SizedBox(height: 5.h),
                                          Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildTextField(
                                      "Name",
                                      "ใส่ข้อมูลชื่อเกม",
                                      _nameController,
                                    ),
                                    _buildTextField(
                                      "Size",
                                      "ใส่ข้อมูลพื้นที่ของแอป",
                                      _sizeController,
                                    ),
                                    _buildTextField(
                                      "Price",
                                      "ใส่ข้อมูลราคาของแอป",
                                      _priceController,
                                    ),
                                    _buildTextField(
                                      "Total downloads",
                                      "ใส่ข้อมูลยอดดาวน์โหลด",
                                      _downloadsController,
                                    ),
                                    _buildTextField(
                                      "Description",
                                      "ใส่ข้อมูลคำอธิบายของแอป",
                                      _descriptionController,
                                      maxLines: 3,
                                    ),

                                    SizedBox(height: 20.h),
                                    _buildImageUploader(
                                      'Banner Image',
                                      type: 'banner',
                                    ),
                                    _buildImageUploader(
                                      'Screenshot Image',
                                      type: 'screenshot',
                                    ),

                                    SizedBox(height: 50.h),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.all(16.w),
                            color: Colors.grey[400],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text("คำเตือน"),
                                            ],
                                          ),
                                          content: Text(
                                            "คุณต้องการเพิ่มแอปนี้ใช่หรือไม่",
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(); // ปิด dialog แรก
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "เพิ่มไม่สำเร็จ",
                                                          ),
                                                        ],
                                                      ),
                                                      content: Text(
                                                        "คุณได้ยกเลิกการเพิ่มแอปนี้",
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop(); // ปิด dialog
                                                          },
                                                          style:
                                                              ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.blue,
                                                              ),
                                                          child: Text(
                                                            "ตกลง",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "NO",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(); // ปิด dialog แรก
                                                _submitGame(); // เรียกฟังก์ชันเพื่อส่งข้อมูล
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: Text(
                                                "YES",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    'ยืนยัน',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                ManageApp(user: widget.user),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black45),
            ),
          ),
          Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildImageUploader(String label, {required String type}) {
    File? imageFile = type == 'banner' ? _bannerImage : _screenshotImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => _pickImage(type),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 163, 165, 151),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child:
                  imageFile != null
                      ? Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                      : Icon(Icons.camera_alt, size: 40, color: Colors.black54),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
