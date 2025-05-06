import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/admin/model/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final addItemProvider = StateNotifierProvider<AddItemNotifier, Item>((ref) {
  ref.keepAlive();
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<Item> {
  AddItemNotifier() : super(Item(null, false, null, [], [], [], false, null)) {
    fetctCategory();
  }

  final CollectionReference items = FirebaseFirestore.instance.collection(
    'items',
  );
  final CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        state = state.copyWith(image: pickedFile.path);
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectCategory(String? category) {
    state = state.copyWith(seletedCategory: category);
  }

  void addSize(String size) {
    state = state.copyWith(size: [...state.sizes, size]);
  }

  void removeSzie(String size) {
    state = state.copyWith(size: state.sizes..remove(size));
  }

  void addColor(String color) {
    state = state.copyWith(color: [...state.colors, color]);
  }

  void removeColor(String color) {
    state = state.copyWith(color: state.colors..remove(color));
  }

  void toggleDiscount(bool? isDiscount) {
    state = state.copyWith(isDiscount: isDiscount);
  }

  void setDiscountPercentage(String? discountPercentage) {
    state = state.copyWith(discountPercentage: discountPercentage);
  }

  void setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> fetctCategory() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      List<String> categories =
          querySnapshot.docs.map((e) => e['name'] as String).toList();
      state = state.copyWith(categories: categories);
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }

  void AddItem(String name, String price) async {
    // Input validation
    if (name.isEmpty ||
        price.isEmpty ||
        state.sizes.isEmpty ||
        state.colors.isEmpty ||
        state.seletedCategory == null ||
        (state.isDiscount! && state.discountPercentage == null)) {
      throw Exception("Size and color are required");
    }

    // Validate image file
    if (state.image == null || !File(state.image!).existsSync()) {
      throw Exception("Image file is missing or invalid");
    }

    state = state.copyWith(isLoading: true);

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('items/$fileName');

      // Upload file
      final uploadTask = ref.putFile(File(state.image!));
      final snapshot = await uploadTask;
      if (snapshot.state != TaskState.success) {
        throw Exception("File upload failed");
      }

      // Get download URL
      final imageUrl = await ref.getDownloadURL();

      // Verify admin privileges
      final user = FirebaseAuth.instance.currentUser;
      // final idTokenResult = await user?.getIdTokenResult();
      // if (idTokenResult?.claims != true) {
      //   throw Exception("Only admins can add items");
      // }

      // Add to Firestore
      await FirebaseFirestore.instance.collection('items').add({
        'name': name,
        'price': double.parse(price),
        'image': imageUrl,
        'size': state.sizes,
        'colors': state.colors,
        'category': state.seletedCategory,
        'isDiscount': state.isDiscount,
        'discountPercentage': state.discountPercentage,
        'userId': user!.uid,
      });
    } on FirebaseException catch (e) {
      if (e.code.contains('storage')) {
        throw Exception('Storage error: ${e.message}');
      } else {
        throw Exception('Firestore error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error adding item: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
