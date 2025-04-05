import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';
import 'futures/DetailPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 2;
  late TabController _tabController;
  bool isLoading = true;
  bool isTyping = false;
  bool isFocused = false;
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<Map<String, String>> allApps = [
    {
      "name": "Netflix",
      "downloads": "10M",
      "size": "100MB",
      "price": "THB 69.00",
    },
    {"name": "Notion", "downloads": "5M", "size": "50MB", "price": "Free"},
    {
      "name": "Nova Launcher",
      "downloads": "2M",
      "size": "25MB",
      "price": "THB 19.00",
    },
    {
      "name": "Nike Run Club",
      "downloads": "8M",
      "size": "75MB",
      "price": "Free",
    },
    {
      "name": "NFS Heat",
      "downloads": "15M",
      "size": "1GB",
      "price": "THB 199.00",
    },
    {"name": "Facebook", "downloads": "50M", "size": "200MB", "price": "Free"},
    {"name": "Instagram", "downloads": "40M", "size": "180MB", "price": "Free"},
    {"name": "Twitter", "downloads": "30M", "size": "150MB", "price": "Free"},
  ];
  List<Map<String, String>> filteredApps = [];

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
          isFocused = true;
          filteredApps = allApps;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
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
        filteredApps = allApps;
      } else {
        filteredApps =
            allApps
                .where((app) => app["name"]!.toLowerCase().startsWith(query))
                .toList();
      }
      isTyping = query.isNotEmpty;
    });
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
              : Container(
                color: Color(0xFF205568),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
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
                                focusNode: focusNode,
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredApps.length,
                        itemBuilder: (context, index) {
                          var app = filteredApps[index];
                          return GestureDetector(
                            onTap: () {
                              print("Tapped on: ${app["name"]}");
                              // เมื่อคลิกที่แถวทั้งแถวจะไปที่หน้า DetailPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailPage(
                                        app: app,
                                      ), // ส่งข้อมูล app ไปยังหน้า DetailPage
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(width: 40.w, height: 40.h),
                                ),
                                title: Text(
                                  app["name"]!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Downloads: ${app["downloads"]}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Size: ${app["size"]}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  width: 90.w,
                                  height: 30.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        app["price"] == "Free"
                                            ? Colors.green
                                            : Colors.blue,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    app["price"]!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
