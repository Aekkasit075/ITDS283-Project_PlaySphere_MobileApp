import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../HomePage.dart';
import '../SearchPage.dart';
import '../MyProfilePage.dart';
import '../MyCartPage.dart';
import '../ManageApp.dart';
import 'AddApp.dart';

class EditAppPage extends StatefulWidget {
  @override
  _EditAppPageState createState() => _EditAppPageState();
}

class _EditAppPageState extends State<EditAppPage>
    with SingleTickerProviderStateMixin {
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
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ), 
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
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Edit App",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: Center(child: Text("หน้านี้สำหรับแก้ไขแอป")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
