// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchScreen extends HookWidget {
  final String? category;
  const SearchScreen({this.category});

  @override
  Widget build(BuildContext context) {
    final CollectionReference itemsCollection = FirebaseFirestore.instance
        .collection('items');
    return StreamBuilder<QuerySnapshot>(
      stream:
          itemsCollection.where('category', isEqualTo: category).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshoot) {
        if (snapshoot.data == null) return CircularProgressIndicator();
        final data = snapshoot.data!.docs;
        return Column(
          children: List.generate(
            data.length,
            (i) => Text('${data[i]['name']}'),
          ),
        );
      },
    );
  }
}
