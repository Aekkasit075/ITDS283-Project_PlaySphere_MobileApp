import 'package:flutter/material.dart';
import 'CheckOutPage.dart';
import '../MyCartPage.dart';
import 'user_model.dart';

class PaymentPage extends StatefulWidget {
  final UserModel user;
  final String selectedPaymentMethod;

  const PaymentPage({super.key, required this.selectedPaymentMethod, required this.user});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF205568),
      appBar: AppBar(
        backgroundColor: const Color(0xFF205568),
        elevation: 0,
        title: const Text(
          'หน้าชำระเงิน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1F5B64),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF4D4C52),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemCard(),
                const SizedBox(height: 10),
                _buildItemCard(),
                const SizedBox(height: 10),
                _buildSummary(),
                const SizedBox(height: 10),
                Container(height: 20, color: Colors.white),
                const SizedBox(height: 10),
                _buildPaymentMethod(),
                const Spacer(),
                _buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(width: 80, height: 80, color: Color(0xFFD9D9D9)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'THB69.00',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white, thickness: 1), // เส้นใต้
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สรุปรายการ:',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('- Name', style: TextStyle(color: Colors.white)),
            Text('THB69.00', style: TextStyle(color: Colors.white)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('- Name', style: TextStyle(color: Colors.white)),
            Text('THB69.00', style: TextStyle(color: Colors.white)),
          ],
        ),
        const Divider(color: Colors.white, thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'รวมทั้งหมด',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'THB138.00',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'วิธีชำระเงิน: ${widget.selectedPaymentMethod.isNotEmpty ? widget.selectedPaymentMethod : "ไม่ระบุ"}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CheckOutPage(user: widget.user)),
                );
              },
              child: const Text(
                '(เปลี่ยน)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
              activeColor: Colors.green,
              checkColor: Colors.white,
            ),
            const Expanded(
              child: Text(
                'ยอมรับข้อกำหนดของการชำระเงิน เมื่อตกลงคำสั่งข้างล่าง จะดำเนินธุรกรรมต่อไป',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isChecked ? Colors.green : Color(0xFFA2A2A2),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isChecked ? _showPaymentSuccessDialog : null,
        child: const Text(
          'ยืนยันการสั่งซื้อ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog() {
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
                'ชำระเงินสำเร็จ',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCartPage(user: widget.user),
                    ), // Navigate to MyCartPage
                  );
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
