import 'package:money_manager/models/category.dart';

class Defaults {
  final List<Category> defaultCategories = [
    //income
    Category(categoryName: 'Salary', type: CategoryType.income),
    Category(categoryName: 'Investment', type: CategoryType.income),

    //expense
    Category(categoryName: 'Vehicle', type: CategoryType.expense),
    Category(categoryName: 'Food', type: CategoryType.expense),
    Category(categoryName: 'Transportation', type: CategoryType.expense),
    Category(categoryName: 'Shopping', type: CategoryType.expense),
    Category(categoryName: 'Fuel', type: CategoryType.expense),
    Category(categoryName: 'Mobile', type: CategoryType.expense)
  ];
}
