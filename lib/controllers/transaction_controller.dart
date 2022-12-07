import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/models/transaction.dart';

class TransactionController extends GetxController {
  late Box<Transaction> box;
  late List<Transaction> allTransactions;
  late List<Transaction> filterdList;
  late DateTime startDate;
  late DateTime endDate;
  String currPeriod = '';

  bool isFilterEnabled = false;
  TransactionController() {
    box = Hive.box<Transaction>('transactions');
    _refreshList();
  }
  addTransaction(Transaction transaction) {
    box.add(transaction);
    _refreshList();
    update();
  }

  updateTransaction(key, Transaction transaction) {
    box.put(key, transaction);
    _refreshList();
    update();
  }

  deleteTransaction(Transaction transaction) {
    if (box.values.contains(transaction)) {
      box.delete(transaction.key);
      allTransactions.remove(transaction);
      if (filterdList.contains(transaction)) {
        filterdList.remove(transaction);
      }
      update();
    }
  }

  setFilter(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    isFilterEnabled = true;
    _refreshList();
    update();
  }

  clearFilter() {
    isFilterEnabled = false;
    _refreshList();
    update();
  }

  _refreshList() {
    allTransactions = box.values.toList();
    if (isFilterEnabled) {
      filterdList = allTransactions
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .toList();
    } else {
      filterdList = allTransactions;
    }

    filterdList.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Transaction>> getTransactions() {
    return Future.value(box.values.toList());
  }

  // Box get transactionBox => box;

}
