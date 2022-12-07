import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category.dart';

class CategoryController extends GetxController {
  late Box<Category> box;
  CategoryController() {
    box = Hive.box<Category>('categories');
  }

  addCategory(Category newCategory) {
    box.add(newCategory);
    update();
  }

  updateCategory(key, Category category) {
    box.put(key, category);
    update();
  }

  deleteCategory(Category category) {
    category.delete();

    update();
  }

  List<Category> getActiveCategories(int type) {
    return box.values
        .where((category) => category.type == type && !category.isDeleted)
        .toList();
  }

  bool isCateoryExist(String name) {
    for (Category category in box.values) {
      if (category.categoryName.toLowerCase() == name.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  //Box get cateoryBox => box;
  static Box<Category> getCategoriesBox() {
    return Hive.box<Category>('categories');
  }
}
