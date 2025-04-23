import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final User? user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('users');

    void logout() {
      authService.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: userCollection.doc(user!.uid).get(),
          builder: (context, AsyncSnapshot snapShot) {
            if (snapShot.hasError) {
              return Text("Error ");
            }
            if (snapShot.data == null) return CircularProgressIndicator();
            var name = snapShot.data['name'];
            var email = snapShot.data['email'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30.h),
                ),
                Text(
                  email,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.h),
                ),
              ],
            );
          },
        ),
        ElevatedButton(onPressed: logout, child: Text("Logout")),
      ],
    );
  }
}
