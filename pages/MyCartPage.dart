import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'HomePage.dart';
import 'ManageApp.dart';
import 'SearchPage.dart';
import 'MyProfilePage.dart';
import 'futures/CheckOutPage.dart';
import 'futures/user_model.dart';
import 'futures/cart_provider.dart';
import 'package:provider/provider.dart';
import '../config.dart';

class MyCartPage extends StatefulWidget {
  final UserModel user;

  MyCartPage({required this.user});

  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 4;
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
      if (mounted) {
        setState(() {
          selectedIndex = _tabController.index;
        });
      }
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

  void _DeleteAllSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 30),
              const SizedBox(height: 10),
              const Text(
                'ลบรถเข็นทั้งหมดสำเร็จ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // เมื่อกด OK ให้ปิดทั้ง 2 Dialog
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context); // ปิดทั้ง 2 Dialog
                  }
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _DeleteAllCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text("ยืนยันการลบ"),
            ],
          ),
          content: Text("คุณยืนยันที่จะลบรถเข็นทั้งหมดหรือไม่?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog ถ้ากด "No"
              },
              child: Text("No", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                // เรียกใช้ CartProvider เพื่อเคลียร์สินค้าทั้งหมด
                Provider.of<CartProvider>(context, listen: false).clearCart();

                // หลังจากลบทั้งหมดให้แสดง success dialog
                _DeleteAllSuccessDialog();
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final totalPrice = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                color: const Color(0xFF205568),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "รถเข็นของฉัน",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "จำนวนตะกร้า: ${cartItems.length}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CheckOutPage(
                                      user: widget.user,
                                      cartItems:
                                          cartItems, // ส่งรายการสินค้าทั้งหมด
                                      totalPrice: totalPrice,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFA2A2A2),
                          ),
                          child: Text(
                            "ชำระเงินทั้งหมด",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          ":รวม THB${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: _DeleteAllCartDialog,
                          child: Text(
                            "ลบตะกร้าทั้งหมด",
                            style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final cartItems = cartProvider.items;

                          if (cartItems.isNotEmpty) {
                            return ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                return _buildCartItem(cartItems[index]);
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                "ไม่มีสินค้าในรถเข็น",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // ทำให้รูปมุมมน
                child: Image.network(
                  '${AppConfig.baseUrl}/${item["game_profile"]}', // รูปเกม
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover, // ให้รูปเต็ม container แบบสวยงาม
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 80.w,
                        height: 80.h,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(item["size"]),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${item["price"]}",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  try {
                    // ลบคำว่า "THB " หรือสิ่งที่ไม่ใช่ตัวเลขออกจาก price
                    String priceString = item["price"].toString().replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    );

                    // แปลงเป็น double
                    double price = double.parse(priceString);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CheckOutPage(
                              user: widget.user,
                              cartItems: [item],
                              totalPrice: price, // ส่งราคาที่แปลงแล้ว
                            ),
                      ),
                    );
                  } catch (e) {
                    // ถ้าแปลงราคาไม่สำเร็จ จะแสดงข้อความผิดพลาด
                    print("Error parsing price: $e");
                  }
                },
                child: Text("ชำระเงิน"),
              ),
              GestureDetector(
                onTap: () {
                  cartProvider.removeItem(item["id"]); // 👈 ลบสินค้าด้วย id
                },
                child: Text(
                  "ลบรายการ",
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
