import 'package:flutter/material.dart';
import 'PaymentPage.dart';
import 'user_model.dart';

class CheckOutPage extends StatefulWidget {
  final UserModel user;

  CheckOutPage({required this.user});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String? _selectedPaymentMethod = "none";

  final Map<String, String> _paymentMethods = {
    'none': 'กรุณาเลือกวิธีชำระเงิน',
    'paypal': 'PayPal',
    'visa': 'Visa',
    'truemoney': 'TrueMoney',
    'online_banking': 'ธนาคารออนไลน์',
    'eclub_points': 'eClub Points',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'วิธีชำระเงิน',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF1F5B64),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1F5B64),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF4D4C52),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'โปรดเลือกวิธีชำระเงิน',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  dropdownColor: Color(0xFF2F2F2F),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF444444),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: _selectedPaymentMethod,
                  items:
                      _paymentMethods.keys.map((paymentMethod) {
                        return DropdownMenuItem(
                          value: paymentMethod,
                          child: Text(
                            _paymentMethods[paymentMethod]!,
                            style: TextStyle(
                              color:
                                  paymentMethod == 'none'
                                      ? Colors.grey
                                      : Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),

                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _selectedPaymentMethod == "none"
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PaymentPage(
                                        user: widget.user,
                                        selectedPaymentMethod:
                                            _paymentMethods[_selectedPaymentMethod] ?? "ไม่ระบุ",
                                      ),
                                ),
                              );
                            },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _selectedPaymentMethod == "none"
                              ? Color(0xFFA2A2A2) // ปิดปุ่ม
                              : Colors.green, // เปิดปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'ดำเนินการต่อ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
