// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/components/customDropDown.dart';
import 'package:e_commerc_app/components/product_cart.dart';
import 'package:e_commerc_app/components/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends HookWidget {
  final String? category;
  const SearchScreen({this.category});

  @override
  Widget build(BuildContext context) {
    final CollectionReference itemsCollection = FirebaseFirestore.instance
        .collection('items');
    final List<Map<String, dynamic>> filters = [
      {
        'category': ['Man', 'Woman', 'Kid'],
      },
      {
        'size': ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      },
      {
        'color': ['Red', 'Yellow', 'Black', 'Green'],
      },
      {
        'Price from': ['1', '10', '20', '30', '40', '50', '60'],
      },
      {
        'To': ['1', '10', '20', '30', '40', '50', '60'],
      },
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Search Field
          SearchField(onchange: (value) {}),

          //filter Design
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream:
                      itemsCollection
                          .where('category', isEqualTo: category)
                          .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshoot) {
                    if (snapshoot.data == null)
                      return CircularProgressIndicator();
                    final data = snapshoot.data!.docs;
                    return Expanded(
                      //color: Colors.amber,
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: GridView.builder(
                          itemCount: data.length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                crossAxisCount: 2,
                              ),
                          itemBuilder:
                              (context, index) =>
                              //color: Colors.amber,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          5.h,
                                        ),
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder: (
                                            context,
                                            url,
                                            progress,
                                          ) {
                                            return CircularProgressIndicator();
                                          },
                                          fit: BoxFit.cover,
                                          imageUrl: data[index]['image'],
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    SizedBox(
                                      height: 33.h,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data[index]['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.h,
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      '${data[index]['price']}\$',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11.h,
                                                    color: Colors.grey.shade400,
                                                    decoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${data[index]['discountPercentage']}%',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 10.h,
                                                        color:
                                                            Colors.red.shade400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: List.generate(5, (
                                                  index,
                                                ) {
                                                  return Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 10.h,
                                                  );
                                                }),
                                              ),
                                              Text(
                                                "0\$",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                  fontSize: 10.h,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
                IntrinsicHeight(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          filters.map((filter) {
                            final key = filter.keys.first;
                            final values = filter.values.first;
                            return CustomDropDown(
                              (value) {},
                              items: values,
                              label: key,
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
