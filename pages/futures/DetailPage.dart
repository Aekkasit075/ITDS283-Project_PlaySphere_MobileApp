import 'package:flutter/material.dart';
import 'CheckOutPage.dart';
import '../MyCartPage.dart';

class DetailPage extends StatefulWidget {
  final Map<String, String> app;

  const DetailPage({Key? key, required this.app}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, String>> comments = [];
  bool isDownloading = false;
  bool isDownloaded = false;
  

  void _showCommentDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Text(
                        "Account",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.account_circle),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Text Field
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "พิมพ์สิ่งที่คุณต้องการบอกผู้อื่น...",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Message Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      setState(() {
                        comments.add({
                          "user": "Account",
                          "text": _controller.text.trim(),
                        });
                      });
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("message"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;

    return Scaffold(
      backgroundColor: Color(0xFF205568),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 150, color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(width: 50, height: 50, color: Colors.white),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app["name"] ?? "Unknown",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "ยอดดาวน์โหลด ${app["downloads"]}",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        "พื้นที่ ${app["size"]}",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () async {
                          final price = app["price"] ?? "";

                          if (price == "Free") {
                            if (!isDownloaded && !isDownloading) {
                              setState(() {
                                isDownloading = true;
                              });

                              await Future.delayed(Duration(seconds: 2));

                              setState(() {
                                isDownloading = false;
                                isDownloaded = true;
                              });
                            }
                          } else if (price.startsWith("THB")) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF4D4C52),
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Header with custom background color (Inside the dialog)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFF4D4C52,
                                            ), // Background color for the header
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 15,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Put in your cart!!!",
                                                style: TextStyle(
                                                  color:
                                                      Colors.white, 
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text(
                                                  "back",
                                                  style: TextStyle(
                                                    color: Colors.grey[300], 
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // The rest of the dialog content
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Image placeholder
                                            Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            // Name and size details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    app["name"] ?? "Unknown",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "พื้นที่ ${app["size"] ?? ""}",
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    app["price"] ?? "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),

                                        // Action buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Payment button
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) => CheckOutPage(),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF4D4C52,), 
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                "ชำระเงิน",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            // Add to cart button
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // Show success dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: Color(
                                                            0xFF5C4033,
                                                          ),
                                                          width: 4,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20.0,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "Put in your cart!!!",
                                                              style: TextStyle(
                                                                color:Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Icon(
                                                              Icons.check_circle_outline,
                                                              color:Colors.green,
                                                              size: 50,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "เพิ่มลงรถเข็นสำเร็จแล้ว",
                                                              style: TextStyle(
                                                                color:Colors.black,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () => Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Color(
                                                                          0xFF4D4C52,
                                                                        ),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "ตกลง",
                                                                    style: TextStyle(
                                                                      color:Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                          (_,) =>
                                                                          MyCartPage(),
                                                                      ),
                                                                    );
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:Colors.blue,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "ดูตะกร้า",
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                "เพิ่มลงตะกร้า",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Builder(
                          builder: (context) {
                            if (isDownloaded) {
                              return Text("Play");
                            } else if (isDownloading) {
                              return SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              );
                            } else {
                              return Text(app["price"] ?? "N/A");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white30),

            // Review Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Review", style: TextStyle(color: Colors.white)),
                  GestureDetector(
                    onTap: () => _showCommentDialog(context),
                    child: Text(
                      "comment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            comments.isEmpty
                ? Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: Colors.teal[700],
                  child: Text(
                    "unreview...",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children:
                        comments.map((c) {
                          return Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(15),
                            width: 200,
                            color: Colors.teal[700],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      c["user"]!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  c["text"]!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),

            // Screenshot Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Screenshots",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 200,
                    height: 120,
                    color: Colors.grey[400],
                    child: Center(child: Text("รูป ${index + 1}")),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("คำอธิบาย", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "แอป ${app["name"]} ได้รับการดาวน์โหลดมากกว่า ${app["downloads"]} ครั้ง!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
