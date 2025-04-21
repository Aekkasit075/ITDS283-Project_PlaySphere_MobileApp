import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ManageApp.dart';
import 'SearchPage.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';
import 'futures/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController _tabController;
  bool isLoading = true;
  List<dynamic> games = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });

    _fetchGames();
  }

  Future<void> _fetchGames() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/games'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        games = data['games'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = HomePage(user: widget.user);
        break;
      case 1:
        targetPage = ManageApp(user: widget.user);
        break;
      case 2:
        targetPage = SearchPage(user: widget.user);
        break;
      case 3:
        targetPage = MyProfilePage(user: widget.user);
        break;
      case 4:
        targetPage = MyCartPage(user: widget.user);
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
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/ดาวน์โหลด.jpg',
                      width: double.infinity,
                      height: 300.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Top Games",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return Container(
                            width: 80.w,
                            margin: EdgeInsets.only(right: 10.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  game["game_profile"] != null
                                      ? Image.network(
                                        '${AppConfig.baseUrl}/${game["game_profile"]}',
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 80.w,
                                        height: 80.h,
                                        color: Colors.grey.shade400,
                                        child: Icon(Icons.broken_image),
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
