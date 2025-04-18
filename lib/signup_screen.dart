import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // ฟังก์ชันในการส่งข้อมูลไปยัง API
  Future<void> _registerUser() async {
    final url = Uri.parse("${AppConfig.baseUrl}/register"); // ใส่ URL ของ API ที่ต้องการเชื่อมต่อ

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',  // กำหนด Content-Type เป็น JSON
        },
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'username': _usernameController.text,
        }),
      );

      if (response.statusCode == 201) {
        // ถ้าการสมัครสำเร็จ
        _showSuccessDialog();
      } else {
        // ถ้ามีข้อผิดพลาด
        _showErrorDialog('Registration failed');
      }
    } catch (e) {
      // กรณีที่เกิดข้อผิดพลาดในการเชื่อมต่อ
      _showErrorDialog('Failed to connect to the server');
    }
  }

  // แสดง Dialog ถ้าการสมัครสำเร็จ
  void _showSuccessDialog() {
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
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign up succeeded',
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
                  Navigator.pop(context);  // ปิด dialog
                  Navigator.pop(context);  // กลับไปหน้าก่อนหน้า
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // แสดง Dialog ถ้ามีข้อผิดพลาด
  void _showErrorDialog(String message) {
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
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Navigator.pop(context);  // ปิด dialog
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
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
    return Scaffold(
      backgroundColor: const Color(0xFF205568),
      appBar: AppBar(
        backgroundColor: const Color(0xFF205568),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Logo Image
            Image.asset('assets/PlaySphere_Logo.png', width: 211),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    'Email',
                    Icons.mail,
                    'Enter your email',
                    false,
                    _emailController,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'Password',
                    Icons.lock,
                    'Enter your password',
                    true,
                    _passwordController,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'Username',
                    Icons.person,
                    'Enter your username',
                    false,
                    _usernameController,
                  ),
                  const SizedBox(height: 40),
                  // Sign Up Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      onPressed: _registerUser,  // เรียกฟังก์ชันการสมัคร
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF205568),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    String hint,
    bool obscure,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            prefixIcon: Icon(icon, color: Colors.black),
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
