import 'package:e_commerc_app/admin/controllers/add_item_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useState(0);
    final selectColor = useState(0);
    final selectSize = useState(0);
    final pageController = usePageController();
    final isFavorite = useState(false);
    final pages = [
      Container(
        color: Colors.amber,
        child: Image.asset('assets/images/f1.jpg'),
      ),
      Container(color: Colors.red),
      Container(color: Colors.green),
    ];

    final colors = [Colors.amber, Colors.red, Colors.green, Colors.blue];
    final sizes = ['XS', 'S', 'M', 'L', 'Xl', 'XXL'];
    final productsImages = [
      'assets/images/f1.jpg',
      'assets/images/f2.jpg',
      'assets/images/f3.jpg',
    ];

    return Scaffold(
      appBar: AppBar(title: Text("ProductName")),
      body: SingleChildScrollView(
        child: Column(
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
                        return Container(
                          color: Colors.amber,
                          child: Image.asset(productsImages[index]),
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
                        "Product Name",
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
                          color: isFavorite.value ? Colors.red : Colors.black,
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
                        "100\$",
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                      Text(
                        "89\$",
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
                      4,
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
                            color: colors[index],
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
                              strokeAlign: BorderSide.strokeAlignOutside,
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
                onTap: () {},
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
