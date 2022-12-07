import 'package:get/get.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/transaction.dart';

class DiaryController extends GetxController {
  final DateTime now = DateTime.now();
  late DateTime selDate;
  List<Transaction> incomeTransactions = [];
  List<Transaction> expTransactions = [];
  double totalIncome = 0;
  double totalExpense = 0;
  double dayBalance = 0;
  DiaryController();
  initialize() {
    selDate = DateTime(now.year, now.month, now.day);
    goToDate(selDate);
  }

  goToDate(DateTime date) {
    selDate = date;
    totalIncome = 0;
    totalExpense = 0;
    dayBalance = 0;
    incomeTransactions.clear();
    expTransactions.clear();
    List<Transaction> allTransactions = TransactionController().allTransactions;
    DateTime dayAfter = date.add(const Duration(days: 1));
    List<Transaction> transactions = allTransactions
        .where((element) =>
            (element.date.isAfter(date) || element.date == date) &&
            element.date.isBefore(dayAfter))
        .toList();
    for (Transaction transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
        incomeTransactions.add(transaction);
      } else if (transaction.type == TransactionType.expense) {
        totalExpense += transaction.amount;
        expTransactions.add(transaction);
      }
      dayBalance = totalIncome - totalExpense;
    }
    update();
  }
}
