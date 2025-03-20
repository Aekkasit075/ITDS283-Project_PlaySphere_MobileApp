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
            color: Colors.grey.shade800,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => onItemTapped(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: double.infinity,
                    color:
                        selectedIndex == 0
                            ? Colors.grey.shade600
                            : Colors.transparent,
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
                            ? Colors.grey.shade600
                            : Colors.transparent,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(3, (index) => GameCard()),
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
                  Expanded(child: GameHistoryTable()),
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
    return Column(
      children: [
        Container(width: 80.w, height: 80.h, color: Colors.grey.shade400),
        SizedBox(height: 5.h),
        ElevatedButton(
          onPressed: () {},
          child: Text("play"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ],
    );
  }
}

class GameHistoryTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FractionColumnWidth(0.1),
          1: FractionColumnWidth(0.4),
          2: FractionColumnWidth(0.2),
          3: FractionColumnWidth(0.3),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade400),
            children: [
              TableCell(child: Center(child: Text("ลำดับ"))),
              TableCell(child: Center(child: Text("ชื่อ"))),
              TableCell(child: Center(child: Text("ราคา"))),
              TableCell(child: Center(child: Text(""))),
            ],
          ),
          TableRow(
            children: [
              TableCell(child: Center(child: Text("1"))),
              TableCell(child: Center(child: Text("name"))),
              TableCell(child: Center(child: Text("free"))),
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text("แก้ไข"),
                    ),
                    SizedBox(width: 5.w),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("ลบ"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
