import 'package:e_commerc_app/user/models/item.dart';

abstract class ItemService {
  Future<List<Item>> fetchItem();
}
