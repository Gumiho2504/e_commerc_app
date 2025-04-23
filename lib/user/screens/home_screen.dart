// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:e_commerc_app/admin/controllers/add_item_controller.dart';
import 'package:e_commerc_app/components/banner.dart';
import 'package:e_commerc_app/user/screens/notification_screen.dart';
import 'package:e_commerc_app/user/screens/profile_screen.dart';
import 'package:e_commerc_app/user/screens/search_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({this.initScreen, this.searchByCategory});
  final int? initScreen;
  final String? searchByCategory;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> screens = [
      MainScreen(),
      SearchScreen(category: searchByCategory),
      NotificationScreen(),
      ProfileScreen(),
    ];

    List<Icon> buttomIcons = [
      Icon(Icons.home),
      Icon((Icons.search)),
      Icon(Icons.favorite),
      Icon(Icons.person),
    ];
    final currentScreen = useState(initScreen ?? 0);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(child: screens[currentScreen.value]),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2.h,
        color: Colors.white,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            buttomIcons.length,
            (index) => bottomIcon(currentScreen, buttomIcons[index], index),
          ),
        ),
      ),
    );
  }

  IconButton bottomIcon(
    ValueNotifier<int> currentScreen,
    Icon icon,
    int index,
  ) {
    return IconButton(
      iconSize: 30.h,
      color:
          currentScreen.value == index ? ThemeData().primaryColor : Colors.grey,
      onPressed: () {
        currentScreen.value = index;
      },
      icon: icon,
    );
  }
}

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CollectionReference items = FirebaseFirestore.instance.collection(
      'items',
    );
    final state = ref.watch(addItemProvider);
    final scrollController = useScrollController();
    var cartButton = Stack(
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          color: ThemeData().primaryColor,
          size: 30.h,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 14.h,
            width: 14.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                "${Random().nextInt(100)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    var logo = Container(
      height: 50.h,
      width: 50.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/logo.jpg"),
        ),
      ),
    );
    return Column(
      spacing: 20.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [logo, cartButton],
        ),
        TopBanner(),
        section("Shop by category"),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return Column(
                spacing: 10.h,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(initScreen: 1,searchByCategory: category,),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 15.w),
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/logo.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Text(category),
                ],
              );
            },
          ),
        ),
        section("Curated for you"),
        StreamBuilder(
          stream: items.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }
            final items = snapshot.data!.docs;
            return SizedBox(
              height: 270.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ProductCart(data: items[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Row section(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold),
        ),
        Text("See all"),
      ],
    );
  }
}

class ProductCart extends StatelessWidget {
  const ProductCart({Key? key, required this.data}) : super(key: key);
  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context) {
    final discountPercent = 100.0 - double.parse(data['discountPercentage']);
    final price = data['price'];
    final discountPrice = price * discountPercent / 100;

    final afterDiscountPrice = "9";

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detail');
      },
      child: SizedBox(
        height: 270.h,
        width: 200.w,
        child: Column(
          spacing: 6.h,
          children: [
            Stack(
              children: [
                Container(
                  height: 200.h,
                  width: 200.w,
                  padding: EdgeInsets.all(0.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.h),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data['image']),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.h,
                  child: Container(
                    padding: EdgeInsets.all(2.h),
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.h),
                ),
                RichText(
                  text: TextSpan(
                    text: '${data['price']}\$',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.h,
                      color: Colors.grey.shade400,
                      decoration: TextDecoration.lineThrough,
                    ),
                    children: [
                      TextSpan(
                        text: '${data['discountPercentage']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.h,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.yellow, size: 12.h);
                  }),
                ),
                Text(
                  "$discountPrice\$",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    fontSize: 12.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
