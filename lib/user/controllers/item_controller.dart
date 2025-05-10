import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/user/models/item.dart';
import 'package:e_commerc_app/user/services/item_service.dart';

class ItemController implements ItemService {
  ItemController() {
    fetchItem();
  }
  @override
  Future<List<Item>> fetchItem() async {
    CollectionReference itemCollection = FirebaseFirestore.instance.collection(
      'items',
    );
    try {
      final items = await itemCollection.limit(3).get();
      return items.docs.map((doc) {
        final item = doc.data() as Map<String, dynamic>;
        item['id'] = doc.id;
        return Item.fromFirestore(item);
      }).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
