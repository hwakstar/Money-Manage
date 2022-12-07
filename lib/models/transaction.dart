import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String category;
  @HiveField(3)
  double amount;
  @HiveField(4)
  TransactionType type;
  @HiveField(5)
  String? description;
  Transaction(
      {required this.date,
      required this.category,
      required this.amount,
      required this.type,
      this.description});
  @override
  String toString() {
    return 'date: $date,category: $category,amount: $amount,type: $type, description: $description';
  }
}
