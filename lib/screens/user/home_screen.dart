import 'package:e_commerc_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();
  void logout() async {
    await authService.signOut();
    Navigator.pushNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Home Screen',
              style: TextStyle(
                fontSize: 40.h,
                fontWeight: FontWeight.bold,
                color: ThemeData().primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
