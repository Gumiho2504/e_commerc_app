import 'package:e_commerc_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    void logout() async {
      await authService.signOut();
      Navigator.pushNamed(context, 'login');
    }
    return Scaffold(
      body: Center(
        child: Text("Admin"),
      ),
    );
  }
}
