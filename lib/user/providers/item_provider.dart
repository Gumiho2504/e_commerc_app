import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/controllers/item_controller.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemProvider = Provider<ItemController>((ref) {
  return ItemController();
});

final itemNotiferProvider = NotifierProvider<ItemNotifer, List<Item>>(() {
  return ItemNotifer();
});

class ItemNotifer extends Notifier<List<Item>> {
  static const int _pageSize = 3;
  DocumentSnapshot? _lastDococument;
  bool _hasMore = true;
  bool _isLoading = false;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;
  ItemNotifer() {
    //fetchItems();
  }
  @override
  List<Item> build() {
    return [];
  }

  Future<void> fetchItems({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;
    _isLoading = true;
    try {
      if (isRefresh) {
        _lastDococument = null;
        _hasMore = true;
        state = [];
      }
      //build firestore query
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("items")
          .orderBy('name')
          .limit(_pageSize);
      if (_lastDococument != null) {
        query = query.startAfterDocument(_lastDococument!);
      }

      // fetch document
      final querySnapshoot = await query.get();
      final newItem =
          querySnapshoot.docs.map((doc) {
            final itemMap = doc.data();
            itemMap['id'] = doc.id;
            return Item.fromFirestore(itemMap);
          }).toList();
      // update lastDocument
      _lastDococument =
          querySnapshoot.docs.isNotEmpty ? querySnapshoot.docs.last : null;

      // check has more data or not
      if (newItem.length < _pageSize) {
        _hasMore = false;
      }

      // update state
      state = [...state, ...newItem];
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
    }
  }
}
