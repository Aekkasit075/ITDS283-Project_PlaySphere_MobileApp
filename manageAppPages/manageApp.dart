import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.settings), text: "ManageApp"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.person), text: "MyProfile"),
            Tab(icon: Icon(Icons.shopping_cart), text: "MyCart"),
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 50.w,
            color: const Color(0xFF796F6F),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => onItemTapped(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: double.infinity,
                    color:
                        selectedIndex == 0
                            ? const Color(0xFF878383)
                            : const Color(0xFF796F6F),
                    child: Column(
                      children: [
                        Icon(Icons.apps, color: Colors.white),
                        Text("app", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => onItemTapped(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: double.infinity,
                    color:
                        selectedIndex == 1
                            ? const Color(0xFF878383)
                            : const Color(0xFF796F6F),
                    child: Column(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        Text("add", style: TextStyle(color: Colors.white)),
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
                    child: GameHistoryTable(),
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
        rows: [
          DataRow(cells: [
            DataCell(Center(child: Text("1"))),
            DataCell(Center(child: Text("name"))),
            DataCell(Center(child: Text("free"))),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text("แก้ไข", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 5.w),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("ลบ", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
