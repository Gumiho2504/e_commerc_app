// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/controllers/cart_controller.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:e_commerc_app/user/screens/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({super.key, required this.item});
  final Item item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartService = ref.read(cartProvider.notifier);
    final state = useState(0);
    final selectColor = useState(0);
    final selectSize = useState(0);
    final pageController = usePageController();
    final isFavorite = useState(false);
    final isLoading = useState(false);
    final pages = [
      Container(
        color: Colors.amber,
        child: Image.asset('assets/images/f1.jpg'),
      ),
      Container(color: Colors.red),
      Container(color: Colors.green),
    ];

    final colors = item.colors;
    final sizes = item.size;
    final productsImages = ['${item.image}', '${item.image}', '${item.image}'];
    double? discountPrice;

    useEffect(() {
      if (item.discountPercentage != null) {
        final discountPercent = 100 - double.parse(item.discountPercentage!);
        discountPrice = item.price * discountPercent / 100;
      }
      return null;
    });

    Color getColorFromName(String name) {
      switch (name.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'black':
          return Colors.black;
        case 'white':
          return Colors.white;
        default:
          return Colors.grey; // default color if no match
      }
    }

    useEffect(() {
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text(item.name)),
      body: SingleChildScrollView(
        child:
            isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Column(
                  spacing: 10.h,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      height: 350.h,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 300.h,
                            width: 300.h,
                            child: PageView.builder(
                              onPageChanged: (value) {
                                state.value = value;
                              },
                              itemCount: 3,
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Hero(
                                  tag: "_item_${item.id}",
                                  createRectTween:
                                      (begin, end) =>
                                          RectTween(begin: begin, end: end),
                                  child: CachedNetworkImage(
                                    placeholder:
                                        (context, url) => Skeleton(
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                    imageUrl: productsImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
                            spacing: 3,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pages.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  pageController.animateToPage(
                                    index,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut,
                                  height: 10.h,
                                  width: state.value == index ? 20.h : 10.h,
                                  decoration: BoxDecoration(
                                    color:
                                        state.value == index
                                            ? ThemeData().primaryColor
                                            : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(5.h),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.h,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 18.h,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  isFavorite.value = !isFavorite.value;
                                },
                                child: Icon(
                                  isFavorite.value
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color:
                                      isFavorite.value
                                          ? Colors.red
                                          : Colors.black,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            spacing: 5.w,
                            children: [
                              Text(
                                "Price :",
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),

                              Text(
                                "${item.price}\$",
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${item.discountPercentage}% off",
                                style: TextStyle(
                                  fontSize: 10.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "$discountPrice\$",
                                style: TextStyle(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'About :',
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      ' With above basic overview of RichText widget, let’s now see how we can make use of this widget in realtime',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.grey.shade500,
                                    fontSize: 14.h,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "color",
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            spacing: 5.w,
                            children: List.generate(
                              colors.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  selectColor.value = index;
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 30.h,
                                  decoration: BoxDecoration(
                                    border:
                                        selectColor.value == index
                                            ? Border.all(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignOutside,
                                            )
                                            : Border(),
                                    color: getColorFromName(colors[index]),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Size",
                            style: TextStyle(
                              fontSize: 18.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            spacing: 5.w,
                            children: List.generate(
                              sizes.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  selectSize.value = index;
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 40.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    ),

                                    color:
                                        selectSize.value == index
                                            ? Colors.black
                                            : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      sizes[index],
                                      style: TextStyle(
                                        color:
                                            selectSize.value == index
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  try {
                    isLoading.value = true;
                    await cartService.addToCart(item.id!);
                    await Future.delayed(Duration(milliseconds: 500));
                    isLoading.value = false;
                    Navigator.of(context).pushNamed('cart');
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Container(
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(5.h),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Add To Cart",
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 180.w,

                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(5.h),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "By Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
