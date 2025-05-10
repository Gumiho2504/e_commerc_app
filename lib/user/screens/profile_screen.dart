// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/screens/cart_screen.dart';
import 'package:e_commerc_app/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:e_commerc_app/components/components.dart';
import 'package:e_commerc_app/components/primary_button.dart';
import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:e_commerc_app/user/services/favorite_service.dart';

class ProfileScreen extends HookConsumerWidget {
  final PageController pageController;
  const ProfileScreen({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userQ = ref.watch(userProvider);
    final authService = ref.watch(authRepositoryProvider);
    final User? user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('users');

    void logout() {
      authService.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }

    final settings = [
      {'About us': Icons.question_mark},
      {'Langues': Icons.language},
      {'Privatecy': Icons.privacy_tip},
      {'Logout': Icons.logout},
    ];
    useAutomaticKeepAlive();
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTitle('My Profile'),
        FutureBuilder(
          future: userCollection.doc(user!.uid).get(),
          builder: (context, AsyncSnapshot snapShot) {
            if (snapShot.hasError) {
              return Text("Error ");
            }
            if (snapShot.data == null) return CircularProgressIndicator();
            var name = snapShot.data['name'];
            var email = snapShot.data['email'];
            var id = user.uid;
            return Row(
              spacing: 20.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100.h,
                  width: 100.h,
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeData().primaryColor,
                      width: 3.h,
                      strokeAlign: BorderSide.strokeAlignInside,
                      style: BorderStyle.solid,
                    ),
                    color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(50.h),
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20.h,
                      ),
                    ),
                    Text(
                      'email: $email',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.h,
                      ),
                    ),
                    Text(
                      'id: $id',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.h,
                      ),
                    ),

                    PrimaryButton(label: "Edit Profile"),
                  ],
                ),
              ],
            );
          },
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            contentBox(
              'favorite',
              Icons.favorite_border_outlined,
              context,
              ref.watch(favoriteItemNotifierProvider).length,
              () {
                pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.bounceOut,
                );
              },
            ),
            contentBox(
              'cart',
              Icons.shopping_bag_outlined,
              context,
              ref.watch(cartProvider).length,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
            contentBox('order', Icons.history, context, 0, () {}),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          'Setting',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.h),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5.h),
            ),
            child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, i) {
                final label = settings[i].keys.first;
                final iconData = settings[i].values.first;
                return Column(
                  spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      margin: EdgeInsets.only(bottom: 10.h),
                      height: 50.h,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.1.h),
                          bottom: BorderSide(width: 0.1.h),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10.w,
                            children: [
                              Icon(iconData, size: 16.h),
                              Text(
                                label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.h,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16.h),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // ElevatedButton(onPressed: logout, child: Text("Logout")),
      ],
    );
  }

  contentBox(
    String label,
    IconData iconData,
    BuildContext context,
    int bageCount,
    void Function() onClick,
  ) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.2 - 20.w,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(5.h),
            ),
            child: Column(
              spacing: 3.h,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, color: ThemeData().primaryColor, size: 16.h),
                Text(
                  label,
                  style: TextStyle(
                    color: ThemeData().primaryColor,
                    fontSize: 12.h,
                  ),
                ),
              ],
            ),
          ),
          if (bageCount > 0)
            Positioned(
              top: -1.h,
              right: 0.h,
              child: Container(
                padding: EdgeInsets.all(5.h),
                // alignment: Alignment(0, 0),
                decoration: BoxDecoration(
                  color: Colors.redAccent.shade200,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$bageCount',
                  style: TextStyle(color: Colors.white, fontSize: 9.h),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
