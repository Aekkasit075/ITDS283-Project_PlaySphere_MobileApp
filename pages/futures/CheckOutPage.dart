import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: CheckOutPage(),
    );
  }
}

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String? _selectedPaymentMethod;
  String? _hoveredPaymentMethod;

  final Map<String, String> _paymentMethods = {
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
        title: Text('วิธีชำระเงิน', style: TextStyle(fontSize: 20, color: Colors.white)),
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
              color: Color(0xFF2F2F2F),
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
                  items: _paymentMethods.keys.map((paymentMethod) {
                    return DropdownMenuItem(
                      value: paymentMethod,
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _hoveredPaymentMethod = paymentMethod;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredPaymentMethod = null;
                          });
                        },
                        child: Container(
                          color: _hoveredPaymentMethod == paymentMethod ? Colors.white : Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _paymentMethods[paymentMethod]!,
                            style: TextStyle(
                              color: _hoveredPaymentMethod == paymentMethod ? Colors.black : Colors.white,
                            ),
                          ),
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
                    onPressed: _selectedPaymentMethod != null
                        ? () {
                            // ดำเนินการต่อ
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod != null
                          ? Colors.green
                          : Color(0xFF888888),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('ดำเนินการต่อ', style: TextStyle(color: Colors.white)),
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
