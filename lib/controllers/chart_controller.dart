import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/chart_data_model.dart';
import 'package:money_manager/models/transaction.dart';

abstract class ChartController extends GetxController {
  late Box<Transaction> box;
  late List<Transaction> allTransactions;
  late List<Transaction> filterdList;
  late List<CatChartData> chartDataList;
  List<CatChartData> displyDataList = [];
  int currTypeFilter = 0;
  final DateTime now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  initialize(startDate, endDate) {
    box = Hive.box<Transaction>('transactions');
    allTransactions = box.values.toList();
    setDateFilter(startDate, endDate);
    setTypeFiler(0);
  }

  prev();
  next();
  String getPeriod();

  setTypeFiler(int type) {
    switch (type) {
      case 0:
        displyDataList = chartDataList
            .where((el) => el.type == CategoryType.expense)
            .toList();
        update();
        break;
      case 1:
        displyDataList = chartDataList
            .where((el) => el.type == CategoryType.income)
            .toList();
        update();
        break;
      case 2:
        displyDataList = ChartHelper().getOverViewData(chartDataList);
        update();
        break;
      default:
        break;
    }
    currTypeFilter = type;
  }

  setDateFilter(DateTime startDate, DateTime endDate) {
    this.startDate = startDate;
    this.endDate = endDate;

    filterdList = allTransactions
        .where((element) =>
            (element.date.isAfter(startDate) || element.date == startDate) &&
            element.date.isBefore(endDate))
        .toList();
    chartDataList = ChartHelper().getCatTotals(filterdList);
    setTypeFiler(currTypeFilter);
  }
}

class ChartHelper {
  List<CatChartData> tmpdataList = [];
  List<CatChartData> dataList = [];
  List<CatChartData> getCatTotals(List<Transaction> filteredList) {
    _createEmptyList();
    for (Transaction item in filteredList) {
      int index = tmpdataList.indexWhere((el) => el.category == item.category);
      if (index != -1) {
        tmpdataList[index].toatal += item.amount;
      } else {
        //print('not contains');
      }
    }
    for (CatChartData data in tmpdataList) {
      if (data.toatal > 0) {
        dataList.add(data);
      }
    }
    return dataList;
  }

  _createEmptyList() {
    Box<Category> categoryBox = Hive.box<Category>('categories');
    List<Category> categories = categoryBox.values.toList();
    for (Category category in categories) {
      tmpdataList.add(CatChartData(category.categoryName, category.type, 0));
    }
  }

  getOverViewData(List<CatChartData> allData) {
    List<CatChartData> overviewList = [];
    double totalIncome = 0;
    double totalExpense = 0;
    for (CatChartData data in allData) {
      if (data.type == CategoryType.expense) {
        totalExpense += data.toatal;
      } else if (data.type == CategoryType.income) {
        totalIncome += data.toatal;
      }
    }
    if (totalExpense > 0 || totalIncome > 0) {
      overviewList.add(CatChartData('Income', -1, totalIncome));
      overviewList.add(CatChartData('Expense', -1, totalExpense));
    }
    return overviewList;
  }
}
