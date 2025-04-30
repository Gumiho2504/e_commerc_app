import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/components/product_cart.dart';
import 'package:e_commerc_app/user/screens/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:e_commerc_app/admin/controllers/add_item_controller.dart';
import 'package:e_commerc_app/components/banner.dart';
import 'package:e_commerc_app/user/screens/favorite_screen.dart';
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
      FavoriteScreen(),
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
          child: screens[currentScreen.value],
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
    final CollectionReference categories = FirebaseFirestore.instance
        .collection('categories');
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
    //late List<String> categoriesImage = [];
    final controller = useScrollController();
    useEffect(() {
      controller.addListener(() {
        if (controller.hasClients) {
          if (controller.offset >= controller.position.maxScrollExtent &&
              !controller.position.outOfRange) {
            //debugPrint("Reached the end!");
          }
        }
      });

      return null;
    }, [controller]);

    return SingleChildScrollView(
      child: Column(
        spacing: 20.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [logo, cartButton],
          ),
          TopBanner(),
          section("Shop by category", context),
          SizedBox(
            height: 100.h,
            child: StreamBuilder(
              stream: categories.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final categoryImages =
                    snapshot.data!.docs
                        .map((e) => e['image'] as String)
                        .toList();
                return ListView.builder(
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
                                builder:
                                    (context) => HomeScreen(
                                      initScreen: 1,
                                      searchByCategory: category,
                                    ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15.w),
                            height: 50.h,
                            width: 50.h,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: categoryImages[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) =>
                                        CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Text(category),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          section("Curated for you", context),
          StreamBuilder(
            stream: items.limit(5).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 270.h,
                  child: ListView.separated(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 270.h,
                        width: 270.h,
                        child: SkeletonBox(),
                      );
                    },
                  ),
                );
              }
              final items = snapshot.data!.docs;
              return SizedBox(
                height: 270.h,
                child: ListView.builder(
                  controller: controller,
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
      ),
    );
  }

  Row section(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(initScreen: 1),
                ),
                (route) => false,
              ),
          child: Text("See all"),
        ),
      ],
    );
  }
}
