import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'MyProfilePage.dart';
import 'MyCartPage.dart';
import 'futures/AddApp.dart';
import 'futures/EditApp.dart';
import 'futures/user_model.dart';
import '../config.dart';

class ManageApp extends StatefulWidget {
  final UserModel user;

  ManageApp({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ManageApp>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 1;
  late TabController _tabController;
  bool isLoading = true;

  List<dynamic> gameData = [];

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
    _fetchGameData();
  }

  Future<void> _loadImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  //แสดงข้อมูลตาราง
  Future<void> _fetchGameData() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/games'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      setState(() {
        gameData = body['games'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Function to delete the game with confirmation dialog
  Future<void> _deleteGame(int gameId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text("คำเตือน"),
            ],
          ),
          content: Text("คุณยืนยันที่จะลบเกมนี้หรือไม่?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: Text("ยกเลิก", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("ลบ", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Proceed to delete if user confirmed
      try {
        final response = await http.delete(
          Uri.parse('${AppConfig.baseUrl}/delete_game/$gameId'),
        );

        if (response.statusCode == 200) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10),
                    Text("ลบสำเร็จ"),
                  ],
                ),
                content: Text("แอปของคุณถูกลบเรียบร้อยแล้ว"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text("ตกลง", style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );

          // Update the game data after deletion
          setState(() {
            gameData.removeWhere((game) => game['id'] == gameId);
          });
        } else {
          throw Exception('Failed to delete game');
        }
      } catch (e) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10),
                  Text("ลบไม่สำเร็จ"),
                ],
              ),
              content: Text("เกิดข้อผิดพลาดในการลบเกมนี้"),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("ตกลง", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    }
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
    } else if (index == 5) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddPage(user: widget.user)),
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
                          onTap: () => _onTabSelected(1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            color:
                                selectedIndex == 1
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
                          onTap: () => _onTabSelected(5),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            width: double.infinity,
                            color:
                                selectedIndex == 5
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
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MyApp",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(5, (index) => GameCard()),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "History added myGames",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: GameHistoryTable(
                              user: widget.user,
                              gameData: gameData,
                              deleteGame: _deleteGame,
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
}

class GameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 10.w),
      child: Column(
        children: [
          Container(width: 80.w, height: 80.h, color: Colors.grey.shade400),
          SizedBox(height: 5.h),
          ElevatedButton(
            onPressed: () {},
            child: Text("play", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class GameHistoryTable extends StatelessWidget {
  final UserModel user;
  final List<dynamic> gameData;
  final Future<void> Function(int) deleteGame; 

  GameHistoryTable({required this.user, required this.gameData, required this.deleteGame});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text("ลำดับ")),
          DataColumn(label: Text("ชื่อ")),
          DataColumn(label: Text("ราคา")),
          DataColumn(label: Text("")),
        ],
        rows: gameData.map<DataRow>((game) {
          return DataRow(
            cells: [
              DataCell(Center(child: Text("${game['id']}"))),
              DataCell(Center(child: Text(game['name'] ?? ''))),
              DataCell(Center(child: Text(game['price'] ?? 'free'))),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAppPage(
                              user: user,
                              gameId: game['id'],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text("แก้ไข", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {
                        deleteGame(game['id']); // Call the delete function
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("ลบ", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
