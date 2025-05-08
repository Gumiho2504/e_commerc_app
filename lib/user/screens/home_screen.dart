// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:e_commerc_app/user/services/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:e_commerc_app/admin/controllers/add_item_controller.dart';
import 'package:e_commerc_app/components/banner.dart';
import 'package:e_commerc_app/components/product_cart.dart';
import 'package:e_commerc_app/user/screens/favorite_screen.dart';
import 'package:e_commerc_app/user/screens/profile_screen.dart';
import 'package:e_commerc_app/user/screens/search_screen.dart';
import 'package:e_commerc_app/user/screens/skeleton_box.dart';
import 'package:e_commerc_app/user/services/favorite_service.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key, this.initScreen, this.searchByCategory});
  final int? initScreen;
  final String? searchByCategory;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItemCount = ref.watch(favoriteItemsCountProvider);
    final pageController = usePageController(initialPage: initScreen ?? 0);
    final searchQueryNotfier = ref.read(searchQueryProvider.notifier);
    final List<Widget> screens = [
      MainScreen(pageController: pageController),
      SearchScreen(category: searchByCategory),
      FavoriteScreen(),
      ProfileScreen(),
    ];

    List<IconData> buttomIcons = [
      Icons.home,
      Icons.search,
      Icons.favorite,
      Icons.person,
    ];
    final currentScreen = useState(initScreen ?? 0);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PageView(
            onPageChanged: (value) => currentScreen.value = value,
            controller: pageController,
            children: [
              MainScreen(pageController: pageController),
              SearchScreen(category: searchByCategory),
              const FavoriteScreen(),
              const ProfileScreen(),
            ],
            //itemCount: screens.length,
            // itemBuilder: (context, index) => screens[index],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 2.h,
        color: Colors.white,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            buttomIcons.length,

            (index) => bottomIcon(
              currentScreen,
              buttomIcons[index],
              index,
              favoriteItemCount,

              () {
                searchQueryNotfier.state = null;

                currentScreen.value = index;
                pageController.jumpToPage(
                  currentScreen.value,
                  // duration: Duration(milliseconds: 100),
                  // curve: Curves.bounceIn,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bottomIcon(
    ValueNotifier<int> currentScreen,
    IconData icon,
    int index,
    AsyncValue<int> favoriteItemCount,
    Function() onPressed,
  ) {
    return Stack(
      children: [
        IconButton(
          iconSize: 30.h,
          color:
              currentScreen.value == index
                  ? ThemeData().primaryColor
                  : Colors.grey,
          onPressed: onPressed,
          icon: Icon(icon),
        ),

        if (icon == Icons.favorite)
          favoriteItemCount.when(
            data:
                (count) => Positioned(
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
                        "${count}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            error: (err, stack) => Text('Error: $err'),
            loading: () => CircularProgressIndicator(),
          ),
        Positioned(
          bottom: -2.h,
          left: 0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 5.h,
            width: currentScreen.value == index ? 40.w : 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: ThemeData().primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

final searchQueryProvider = StateProvider<String?>((ref) {
  return null;
});

class MainScreen extends HookConsumerWidget {
  final PageController pageController;
  const MainScreen({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQueryNotfier = ref.read(searchQueryProvider.notifier);
    final CollectionReference items = FirebaseFirestore.instance.collection(
      'items',
    );
    final CollectionReference categories = FirebaseFirestore.instance
        .collection('categories');
    final state = ref.watch(addItemProvider);
    final scrollController = useScrollController(initialScrollOffset: -2000);
    var cartButton = GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('cart'),
      child: Stack(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: ThemeData().primaryColor,
            size: 30.h,
          ),
          if (ref.watch(cartProvider).isNotEmpty)
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
                    "${ref.watch(cartProvider).length}",
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
      ),
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

    final products = ref.watch(itemNotiferProvider);
    final notifier = ref.read(itemNotiferProvider.notifier);
    final controller = useScrollController();
    useEffect(() {
      if (products.isEmpty && notifier.hasMore && !notifier.isLoading) {
        notifier.fetchItems();
      }
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }

      void scrollListener() {
        if (controller.hasClients) {
          if (controller.positions.isNotEmpty) {
            if (controller.offset >= controller.position.maxScrollExtent &&
                !controller.position.outOfRange) {
              if (notifier.hasMore && !notifier.isLoading) {
                notifier.fetchItems();
              }
            }
          }
        }
      }

      controller.addListener(scrollListener);

      return () {
        //controller.dispose();
        // controller.removeListener(scrollListener);
      };
    }, [controller]);
    useAutomaticKeepAlive();
    return SingleChildScrollView(
      child: Column(
        spacing: 20.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [logo, cartButton],
          ),

          const TopBanner(),
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
                            searchQueryNotfier.state = category;
                            pageController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInCirc,
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
          // StreamBuilder(
          //   stream: items.snapshots(),
          //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.data == null ||
          //         snapshot.connectionState == ConnectionState.waiting) {
          //       return SizedBox(
          //         height: 270.h,
          //         child: ListView.separated(
          //           controller: scrollController,
          //           itemCount: 2,
          //           scrollDirection: Axis.horizontal,
          //           separatorBuilder: (context, index) => SizedBox(width: 10.w),
          //           itemBuilder: (context, index) {
          //             return SizedBox(
          //               height: 270.h,
          //               width: 270.h,
          //               child: SkeletonBox(),
          //             );
          //           },
          //         ),
          //       );
          //     }
          //     final items = snapshot.data!.docs;
          //     return SizedBox(
          //       height: 270.h,
          //       child: ListView.builder(
          //         controller: scrollController,
          //         scrollDirection: Axis.horizontal,
          //         itemCount: items.length,
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.only(right: 20),
          //             child: ProductCart(data: items[index]),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          notifier.isLoading
              ? SizedBox(
                height: 270.h,
                child: ListView.separated(
                  // controller: scrollController,
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
              )
              : SizedBox(
                height: 270.h,
                child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ProductCart(item: products[index]),
                    );
                  },
                ),
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
