import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'SearchPage.dart';
import 'MyCartPage.dart';
import '../login_screen.dart';
import 'futures/user_model.dart';

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

  String email = "";
  String username = "";
  String password = "";

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

    email = widget.user.email;
    username = widget.user.username;
    password = widget.user.password;

    _loadImage();
  }

  Future<void> _loadImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
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
                      Text(
                        widget.user.username,
                        style: TextStyle(color: Colors.white),
                      ),
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
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            // ปรับการนำทางตามแท็บที่เลือก
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(user: widget.user),
                ),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageApp(user: widget.user),
                ),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(user: widget.user),
                ),
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
                MaterialPageRoute(
                  builder: (context) => MyCartPage(user: widget.user),
                ),
              );
            }
          },
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
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 60.h,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          username,
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
                          subtitle: Text(email),
                          trailing: Icon(Icons.edit),
                          onTap:
                              () => _editField(
                                "อีเมล",
                                email,
                                (value) => setState(() => email = value),
                              ),
                        ),
                        Divider(color: Colors.grey),
                        ListTile(
                          title: Text("ข้อมูลชื่อบัญชี"),
                          subtitle: Text(username),
                          trailing: Icon(Icons.edit),
                          onTap:
                              () => _editField(
                                "ชื่อบัญชี",
                                username,
                                (value) => setState(() => username = value),
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
                                password,
                                (value) => setState(() => password = value),
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
                        ListTile(
                          title: Text("จำนวนแอปที่เคยเพิ่ม:"),
                          subtitle: Text("2"),
                        ),
                        SizedBox(height: 30.h),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (route) =>
                                    false, // ลบหน้าทุกหน้าก่อนหน้าออกจาก stack
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 20.w,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: Text(
                              "ออกจากระบบ",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
