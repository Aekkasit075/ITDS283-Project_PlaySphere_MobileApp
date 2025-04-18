import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ManageApp.dart';
import 'SearchPage.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';
import 'futures/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  HomePage({required this.user});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // ตรวจสอบให้มั่นใจว่า TabController ถูกกำหนดค่าแล้ว
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });

    // กำหนดเวลาโหลด
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
      selectedIndex = index; // Update selected index
    });

    // นำทางไปยังหน้าอื่น ๆ ตาม index
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
        MaterialPageRoute(builder: (context) => MyProfilePage(user: widget.user)),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyCartPage(user: widget.user)),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose(); 
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfilePage(user: widget.user)),
                    );
                  },
                  child: Row(
                    children: [
                      Text(widget.user.username, style: TextStyle(color: Colors.white)),
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
          controller: _tabController,  // กำหนดค่า TabController ที่นี่
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) 
          : Center(child: Text('MyProfile Page Content')), 
    );
  }
}

