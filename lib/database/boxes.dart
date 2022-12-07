import 'package:hive/hive.dart';
import 'package:money_manager/models/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactionsBox() =>
      Hive.box<Transaction>('transactions');
  static Box getStorageBox() => Hive.box('storage');
}
