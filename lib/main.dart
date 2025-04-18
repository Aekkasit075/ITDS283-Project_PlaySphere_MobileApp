import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'pages/HomePage.dart';
import 'pages/ManageApp.dart';
import 'pages/MyCartPage.dart';
import 'pages/MyProfilePage.dart';
import 'pages/futures/CheckOutPage.dart';
import 'pages/futures/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Project Mobile App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginScreen());
              case '/signup':
                return MaterialPageRoute(builder: (_) => SignUpScreen());
              case '/home':
                final args = settings.arguments as UserModel;
                return MaterialPageRoute(builder: (_) => HomePage(user: args));
              case '/manage':
                final args = settings.arguments as UserModel;
                return MaterialPageRoute(builder: (_) => ManageApp(user: args));
              case '/cart':
                final args = settings.arguments as UserModel;
                return MaterialPageRoute(
                  builder: (_) => MyCartPage(user: args),
                );
              case '/profile':
                final args = settings.arguments as UserModel;
                return MaterialPageRoute(
                  builder: (_) => MyProfilePage(user: args),
                );
              case '/checkout':
                final args = settings.arguments as UserModel;
                return MaterialPageRoute(
                  builder: (_) => CheckOutPage(user: args),
                );
              default:
                return MaterialPageRoute(builder: (_) => LoginScreen());
            }
          },
        );
      },
    );
  }
}
