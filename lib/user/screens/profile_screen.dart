import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:e_commerc_app/components/components.dart';
import 'package:e_commerc_app/components/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTitle('My Profile'),
        Row(
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
                child: Image.asset('assets/images/1.png', fit: BoxFit.cover),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.h),
                ),
                Text(
                  'email: user@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.h),
                ),
                Text(
                  'id: sdhdhiwexddf12mde',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.h),
                ),

                PrimaryButton(label: "Edit Profile"),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            contentBox('favorite', Icons.favorite_border_outlined, context),
            contentBox('cart', Icons.shopping_bag_outlined, context),
            contentBox('order', Icons.history, context),
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

        // FutureBuilder(
        //   future: userCollection.doc(user!.uid).get(),
        //   builder: (context, AsyncSnapshot snapShot) {
        //     if (snapShot.hasError) {
        //       return Text("Error ");
        //     }
        //     if (snapShot.data == null) return CircularProgressIndicator();
        //     var name = snapShot.data['name'];
        //     var email = snapShot.data['email'];
        //     var id = user.uid;
        //     return Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           name,
        //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30.h),
        //         ),
        //         Text(
        //           email,
        //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.h),
        //         ),
        //         Text(
        //           id,
        //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.h),
        //         ),
        //       ],
        //     );
        //   },
        // ),
        // ElevatedButton(onPressed: logout, child: Text("Logout")),
      ],
    );
  }

  contentBox(String label, IconData iconData, BuildContext context) {
    return Stack(
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
        Positioned(
          top: -5.h,
          right: 0.h,
          child: Container(
            padding: EdgeInsets.all(5.h),
            // alignment: Alignment(0, 0),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade200,
              shape: BoxShape.circle,
            ),
            child: Text(
              "1",
              style: TextStyle(color: Colors.white, fontSize: 10.h),
            ),
          ),
        ),
      ],
    );
  }
}
