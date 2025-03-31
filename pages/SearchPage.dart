import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  int selectedIndex = 2;
  late TabController _tabController;
  bool isLoading = true;
  bool isTyping = false; // ใช้เช็คว่าเริ่มพิมพ์หรือยัง
  bool isFocused = false; // ใช้เช็คว่า TextField ถูกเลือก
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode(); // FocusNode สำหรับตรวจจับการคลิก
  List<String> allApps = [
    "Netflix",
    "Notion",
    "Nova Launcher",
    "Nike Run Club",
    "NFS Heat",
    "Facebook",
    "Instagram",
    "Twitter",
  ];
  List<String> filteredApps = [];

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
    searchController.addListener(_filterSearchResults);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isFocused = true; // เมื่อ TextField ถูกเลือก
          filteredApps = allApps; // แสดงรายการทั้งหมดเมื่อคลิก
        });
      } else {
        setState(() {
          isFocused = false; // เมื่อ TextField ถูกคลิกแล้วออก
        });
      }
    });
  }

  Future<void> _loadImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  void _filterSearchResults() {
    String query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredApps = allApps; // เมื่อยังไม่พิมพ์เลย, ให้แสดงรายการทั้งหมด
      } else {
        filteredApps = allApps
            .where((app) => app.toLowerCase().startsWith(query)) // กรองตามคำค้นหาของผู้ใช้
            .toList();
      }
      isTyping = query.isNotEmpty; // ตั้งค่า isTyping เป็น true เมื่อเริ่มพิมพ์
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
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
  void dispose() {
    focusNode.dispose(); // อย่าลืม dispose focusNode
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
                Text("Account", style: TextStyle(color: Colors.white)),
                SizedBox(width: 5.w),
                Icon(Icons.account_circle, color: Colors.white),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFF205568), // Keep the background color as dark blue
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              focusNode: focusNode, // ใช้ FocusNode ที่กำหนด
                              decoration: InputDecoration(
                                hintText: 'Search here...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.search, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Show all results when TextField is focused, then filter when typing
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: isFocused ? 1.0 : 0.0, // ซ่อนพื้นหลังขาวจนกว่าจะคลิก TextField
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // White background when focused
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ListView.builder(
                          itemCount: isTyping ? filteredApps.length : filteredApps.length,
                          itemBuilder: (context, index) {
                            String app = filteredApps[index];
                            return ListTile(
                              title: Text(
                                app,
                                style: TextStyle(color: Colors.black),
                              ),
                              tileColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              onTap: () {
                                print("Selected: $app");
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
