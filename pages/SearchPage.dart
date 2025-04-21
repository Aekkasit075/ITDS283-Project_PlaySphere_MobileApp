import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';
import 'futures/DetailPage.dart';
import 'futures/user_model.dart';
import '../config.dart';

class SearchPage extends StatefulWidget {
  final UserModel user;

  SearchPage({required this.user});

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
  List<Map<String, String>> allApps = [];
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
    _loadApps();
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

  Future<void> _loadApps() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/games'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<Map<String, String>> loadedApps = [];
        for (var item in data['games']) {
          loadedApps.add({
            "id": item['id'].toString(), // แปลงเป็น String
            "name": item['name'] ?? '',
            "downloads": item['total_downloads'].toString(),
            "size": item['size'] ?? '',
            "price":
                item['price'] == null || item['price'].toString() == "0"
                    ? "Free"
                    : "THB ${item['price']}",

            "game_profile": item['game_profile'] ?? '',
            "banner_image": item['banner_image'] ?? '',
            "screenshot_images": item['screenshot_image'] ?? [],
            "description": item['description'] ?? '',
          });
        }

        setState(() {
          allApps = loadedApps;
          filteredApps = loadedApps;
          isLoading = false;
        });
        _loadPriceFromSharedPreferences();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      print("Error loading apps: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ดึงข้อมูลราคาจาก SharedPreferences
  Future<void> _loadPriceFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedGames =
        prefs.getStringList('downloaded_games') ?? [];

    // ค้นหาและอัพเดตราคาในแต่ละเกมที่แสดงผล
    for (int i = 0; i < allApps.length; i++) {
      var app = allApps[i];
      for (String game in downloadedGames) {
        var gameData = jsonDecode(game);
        if (gameData['id'] == app['id']) {
          setState(() {
            allApps[i]['price'] = gameData['price'] ?? 'Free'; // อัพเดตราคา
          });
        }
      }
    }

    setState(() {
      filteredApps = allApps;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
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
                                        user: widget.user,
                                        app: app,
                                      ), // ส่งข้อมูล app ไปยังหน้า DetailPage
                                ),
                              );
                              _loadPriceFromSharedPreferences();
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
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    '${AppConfig.baseUrl}/${app["game_profile"]}',
                                    width: 50.w,
                                    height: 50.h,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                title: Text(
                                  app["name"] ?? '',
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
