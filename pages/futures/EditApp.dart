import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../HomePage.dart';
import '../SearchPage.dart';
import '../MyProfilePage.dart';
import '../MyCartPage.dart';
import '../ManageApp.dart';
import 'AddApp.dart';
import '../../config.dart';
import 'user_model.dart';

class EditAppPage extends StatefulWidget {
  final UserModel user;
  final int gameId;

  EditAppPage({required this.user, required this.gameId});
  @override
  _EditAppPageState createState() => _EditAppPageState();
}

class _EditAppPageState extends State<EditAppPage>
    with SingleTickerProviderStateMixin {
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

  String? _bannerImageUrl;
  String? _screenshotImageUrl;
  String? _gameProfileImageUrl;

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
    _loadGameData();
  }

  Future<void> _loadImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadGameData() async {
    final url = Uri.parse("${AppConfig.baseUrl}/get_game/${widget.gameId}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _nameController.text = data['name'] ?? '';
        _sizeController.text = data['size'] ?? '';
        _priceController.text = data['price']?.toString() ?? 'free';
        _downloadsController.text = data['total_downloads']?.toString() ?? '';
        _descriptionController.text = data['description'] ?? '';

        _bannerImageUrl = "${AppConfig.baseUrl}/${data['banner_image']}";
        _screenshotImageUrl =
            "${AppConfig.baseUrl}/${data['screenshot_image']}";
        _gameProfileImageUrl = "${AppConfig.baseUrl}/${data['game_profile']}";

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitEditGame() async {
    final url = Uri.parse("${AppConfig.baseUrl}/edit_game/${widget.gameId}");
    var request = http.MultipartRequest('PUT', url);

    request.fields['game_name'] = _nameController.text;
    request.fields['size'] = _sizeController.text;
    request.fields['price'] = _priceController.text;
    request.fields['total_downloads'] = _downloadsController.text;
    request.fields['description'] = _descriptionController.text;

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

    if (response.statusCode == 200) {
      _showSuccessDialog();
    } else {
      _showFailureDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("สำเร็จ"),
              ],
            ),
            content: Text("แก้ไขข้อมูลเรียบร้อยแล้ว"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageApp(user: widget.user),
                    ),
                  );
                },
                child: Text("ตกลง"),
              ),
            ],
          ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text("ผิดพลาด"),
              ],
            ),
            content: Text("แก้ไขข้อมูลไม่สำเร็จ กรุณาลองใหม่"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ตกลง"),
              ),
            ],
          ),
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

  Widget _buildImageDisplay(File? imageFile, String? imageUrl) {
    if (imageFile != null) {
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
      );
    } else {
      return Container(
        height: 150,
        color: Colors.grey[300],
        child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
      );
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
                              "Edited Game(ID: ${widget.gameId})",
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
                                  children: [
                                    // 🖼 รูปโปรไฟล์เกม
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
                                                        : _gameProfileImageUrl !=
                                                            null
                                                        ? DecorationImage(
                                                          image: NetworkImage(
                                                            _gameProfileImageUrl!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                        : null,
                                              ),
                                              child:
                                                  (_gameProfileImage == null &&
                                                          _gameProfileImageUrl ==
                                                              null)
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

                                    // 📝 ฟอร์มกรอกข้อมูล
                                    _buildTextField("Name", _nameController),
                                    _buildTextField("Size", _sizeController),
                                    _buildTextField("Price", _priceController),
                                    _buildTextField(
                                      "Total downloads",
                                      _downloadsController,
                                    ),
                                    _buildTextField(
                                      "Description",
                                      _descriptionController,
                                      maxLines: 3,
                                    ),

                                    SizedBox(height: 20.h),

                                    // 📸 รูป Banner
                                    Text(
                                      "รูป Banner",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _pickImage('banner'),
                                      child: _buildImageDisplay(
                                        _bannerImage,
                                        _bannerImageUrl,
                                      ),
                                    ),

                                    SizedBox(height: 20.h),

                                    // 📸 รูป Screenshot
                                    Text(
                                      "รูป Screenshot",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _pickImage('screenshot'),
                                      child: _buildImageDisplay(
                                        _screenshotImage,
                                        _screenshotImageUrl,
                                      ),
                                    ),

                                    SizedBox(height: 30.h),

                                    // ✅ ปุ่มยืนยัน
                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      color: Colors.grey[400],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.warning_amber,
                                                          color: Colors.orange,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text("ยืนยันการแก้ไข"),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      "คุณต้องการแก้ไขแอปนี้ใช่หรือไม่?",
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop(); // ปิด dialog
                                                        },
                                                        child: Text(
                                                          "ยกเลิก",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop(); // ปิด dialog
                                                          _submitEditGame(); // เรียกฟังก์ชันยืนยันการแก้ไข
                                                        },
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                            ),
                                                        child: Text(
                                                          "ยืนยัน",
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
                                              'ยืนยันการแก้ไข',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => ManageApp(
                                                        user: widget.user,
                                                      ),
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
                                              'ยกเลิกการแก้ไข',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(border: InputBorder.none),
          ),
          Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    );
  }
}
