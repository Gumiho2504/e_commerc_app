import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_commerc_app/components/filter_group.dart';
import 'package:e_commerc_app/components/grid_cart.dart';
import 'package:e_commerc_app/components/search_field.dart';
import 'package:e_commerc_app/user/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends HookWidget {
  final String? category;
  const SearchScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final CollectionReference itemsCollection = FirebaseFirestore.instance
        .collection('items');
    final List<Map<String, dynamic>> filters = [
      {
        'category': ['All', 'Man', 'Woman', 'Kid'],
      },
      {
        'size': ['All', 'XS', 'S', 'M', 'L', 'XL', 'XXL'],
      },
      {
        'color': [
          'All',
          'Red',
          'Green',
          'Blue',
          'Yellow',
          'Black',
          'White',
          'Purple',
          'Orange',
          'Pink',
          'Gray',
          'Brown',
          'Cyan',
          'Magenta',
          'Lime',
          'Indigo',
          'Violet',
          'Gold',
          'Silver',
          'Beige',
          'Maroon',
          'Olive',
          'Teal',
          'Navy',
          'Turquoise',
          'Coral',
        ],
      },
      {
        'from': ['All', '1', '10', '20', '30', '40', '50', '60'],
      },
      {
        'To': ['All', '1', '10', '20', '30', '40', '50', '60'],
      },
    ];
    final searchQuery = useState("");
    //final lastDocument = useState<DocumentSnapshot?>(null);
    //final hasMore = useState<bool>(true);
    final queryData = useState<Stream<QuerySnapshot>?>(null);
    final currenentCategory = useState<String?>(category);
    final currenctSelect = useState(0);
    final selectedFilters = useState<Map<String, dynamic>>({
      'category': null,
      'size': null,
      'color': null,
      'from': null,
      'to': null,
    });

    Query buildQuery() {
      Query<Map<String, dynamic>> query = itemsCollection.withConverter(
        fromFirestore:
            (snapshoot, _) => snapshoot.data() as Map<String, dynamic>,
        toFirestore: (value, _) => value,
      );
      if (currenentCategory.value != null) {
        //query = query.where('category', isEqualTo: category);
        final categoryList =
            filters.firstWhere(
                  (element) => element.containsKey('category'),
                )['category']
                as List;

        currenctSelect.value = categoryList.indexOf(currenentCategory.value);
        //print('${categoryList} = ${currenctSelect.value}');
        selectedFilters.value['category'] = currenentCategory.value;
      }

      selectedFilters.value.forEach((key, value) {
        if (value != null) {
          if (key == 'from') {
            query = query.where(
              'price',
              isGreaterThanOrEqualTo: int.parse(value),
            );
          } else if (key == 'to') {
            query = query.where('price', isLessThan: int.parse(value));
          } else if (key == 'category') {
            query = query.where('category', isEqualTo: value);
          } else if (key == 'color') {
            query = query.where(
              'colors',
              arrayContains: value.toString().toLowerCase(),
            );
          } else if (key == 'size') {
            query = query.where('size', isEqualTo: value);
            //isHasContain.value = true;
          } else {
            query = query.where(key, isEqualTo: value);
          }
        }
      });
      if (searchQuery.value.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery.value)
            //.where('price', isGreaterThanOrEqualTo: 20)
            .where('name', isLessThanOrEqualTo: '${searchQuery.value}\uf8ff');
      }
      return query;
    }

    useEffect(() {
      queryData.value = buildQuery().snapshots();

      return () {
        //currenctSelect.value = 0;
        selectedFilters.value['category'] = null;
      };
    }, [category, searchQuery.value, selectedFilters.value]);

    // Load more items
    // Future<void> loadMore() async {
    //   if (!hasMore.value || lastDocument.value == null) return;

    //   final query = buildQuery().startAfterDocument(lastDocument.value!);
    //   final snapshot = await query.get();

    //   if (snapshot.docs.isEmpty) {
    //     hasMore.value = false;
    //   } else {
    //     lastDocument.value = snapshot.docs.last;
    //   }
    // }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Search Field
          SearchField(
            onchange: (value) {
              searchQuery.value = value;
            },
          ),

          //filter Design
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream:
                      // itemsCollection
                      //     .where('category', isGreaterThanOrEqualTo: 'Man')
                      //     .where('price', isGreaterThanOrEqualTo: 20)
                      //     .snapshots(),
                      queryData.value,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshoot) {
                    if (snapshoot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: GridView.builder(
                          itemCount: 6,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                crossAxisCount: 2,
                              ),
                          itemBuilder:
                              (context, index) =>
                                  //color: Colors.amber,
                                  SkeletonBox(),
                        ),
                      );
                    }
                    if (!snapshoot.hasData || snapshoot.data!.docs.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Text(
                          "No items found!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    final data = snapshoot.data!.docs;
                    return
                    //color: Colors.amber,
                    Padding(
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
                            GridCart(data: data[index]),
                      ),
                    );
                  },
                ),
                FilterGroup(
                  filters: filters,
                  currenctSelect: currenctSelect,
                  selectedFilters: selectedFilters,
                  currenentCategory: currenentCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
