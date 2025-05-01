import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService authService = ref.watch(authRepositoryProvider);
    final CollectionReference items = FirebaseFirestore.instance.collection(
      'items',
    );
    final String uuid = FirebaseAuth.instance.currentUser!.uid;
    void logout() async {
      await authService.signOut();
      Navigator.pushNamed(context, 'login');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 10.h,
            children: [
              Text(
                "You Upload Items :",
                style: TextStyle(fontSize: 20.h, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: items.where('userId', isEqualTo: uuid).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final document = snapshot.data!.docs;
                    if (document.isEmpty) {
                      return Text('No Items');
                    }
                    return ListView.builder(
                      cacheExtent: 10,

                      physics: BouncingScrollPhysics(),
                      itemCount: document.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            // contentPadding: EdgeInsets.all(5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                            tileColor: Colors.grey.shade100,
                            titleTextStyle: TextStyle(
                              fontSize: 20.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            subtitleTextStyle: TextStyle(
                              fontSize: 12.h,
                              color: ThemeData().primaryColor,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.h),
                              child: CachedNetworkImage(
                                width: 60.h,
                                height: 60.h,
                                imageUrl: document[index]['image'],
                              ),
                            ),
                            title: Text(document[index]['name']),
                            subtitle: Text(
                              '${document[index]['price']}\$ | ${document[index]['category']}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeData().primaryColor,
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.deepPurpleAccent.shade100.withAlpha(50),
            width: 2.h,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add_item');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 82.h,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.h),
              topRight: Radius.circular(25.h),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: ThemeData().primaryColor,
                  size: 30.h,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.category, color: Colors.black, size: 20.h),
                onPressed: () {
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
