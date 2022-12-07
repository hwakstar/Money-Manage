import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/util.dart';

import 'package:money_manager/widgets/empty_view.dart';
import 'package:money_manager/widgets/tile_transaction.dart';

class TransactionSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Serch Transactions';
  List<Transaction> transactions = TransactionController().allTransactions;
  List<Category> categories = CategoryController.getCategoriesBox()
      .values
      .where((element) => !element.isDeleted)
      .toList();
  final TransactionController transactionController = Get.find();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Transaction> resultList = [];
    for (var item in transactions) {
      if (query.isNotEmpty &&
          item.category.toLowerCase().contains(query.toLowerCase())) {
        resultList.add(item);
      }
    }
    if (query.isNotEmpty && resultList.isEmpty) {
      return const EmptyView(icon: Icons.search, label: 'No Results Found');
    }
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: resultList.length,
          itemBuilder: (context, index) {
            Transaction currItem = resultList[index];
            return TransactionTile(
              transaction: currItem,
              transactionController: transactionController,
              enableSlide: false,
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Category> suggestionList = [];

    for (var item in categories) {
      if (query.isNotEmpty &&
          item.categoryName.toLowerCase().contains(query.toLowerCase())) {
        suggestionList.add(item);
      }
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            final currCat = suggestionList[index];
            return ListTile(
              leading: Util.getCatIcon(currCat.type),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              title: Text(suggestionList[index].categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                query = currCat.categoryName;
                showResults(context);
              },
            );
          }),
    );
  }
}
