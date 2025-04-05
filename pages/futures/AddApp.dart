import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../HomePage.dart';
import '../SearchPage.dart';
import '../MyProfilePage.dart';
import '../MyCartPage.dart';
import '../ManageApp.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  int selectedIndex = 1;
  int sideMenuIndex = 5;
  late TabController _tabController;
  bool isLoading = true;

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

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate based on the selected tab (For the main tabs)
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManageApp()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyProfilePage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyCartPage()),
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
                      MaterialPageRoute(builder: (context) => MyProfilePage()),
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
                                builder: (context) => AddPage(),
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
                                          Container(
                                            height: 80.h,
                                            width: 80.h,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.image,
                                              size: 40,
                                              color: Colors.white,
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
                                    _buildTextField("Name", "ใส่ข้อมูลชื่อเกม"),
                                    _buildTextField(
                                      "Size",
                                      "ใส่ข้อมูลพื้นที่ของแอป",
                                    ),
                                    _buildTextField(
                                      "Price",
                                      "ใส่ข้อมูลราคาของแอป",
                                    ),
                                    _buildTextField(
                                      "Total downloads",
                                      "ใส่ข้อมูลยอดดาวน์โหลด",
                                    ),
                                    _buildTextField(
                                      "Description",
                                      "ใส่ข้อมูลคำอธิบายของแอป",
                                      maxLines: 3,
                                    ),

                                    SizedBox(height: 20.h),
                                    _buildImageUploader('Banner Image'),
                                    _buildImageUploader('Screenshot Image'),

                                    SizedBox(height: 50.h),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ปุ่มกด
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
                                                ).pop(); // Close the first dialog
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
                                                            ).pop(); // Close the second dialog
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
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (
                                                    BuildContext context,
                                                  ) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text("เพิ่มสำเร็จ"),
                                                        ],
                                                      ),
                                                      content: Text(
                                                        "แอปของคุณได้ถูกเพิ่มเรียบร้อยแล้ว",
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            // Close the success dialog
                                                            Navigator.of(
                                                              context,
                                                            ).pop();

                                                            // Navigate to the ManageApp page
                                                            Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ManageApp(),
                                                              ),
                                                            );
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
                                        builder: (context) => ManageApp(),
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

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
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

  Widget _buildImageUploader(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 163, 165, 151),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.camera_alt, size: 40, color: Colors.black54),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
