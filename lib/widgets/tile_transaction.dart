import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/constants/app_theme.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/transaction/add_transaction.dart';
import 'package:money_manager/util.dart';

class TransactionTile extends StatelessWidget {
  TransactionTile(
      {Key? key,
      required this.transaction,
      required this.transactionController,
      this.enableSlide = true})
      : super(key: key);
  final Transaction transaction;
  final TransactionController transactionController;
  final DateTime today = DateTime.now();
  final bool enableSlide;
  final textColors = [Colors.green, Colors.red];
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enableSlide,
      key: ObjectKey(transaction),
      endActionPane: ActionPane(
          extentRatio: 0.25,
          dragDismissible: true,
          motion: const DrawerMotion(),
          children: [
            /*  SlidableAction(
            onPressed: (ctx) {},
            backgroundColor:const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit),*/

            SlidableAction(
              flex: 1,
              autoClose: true,
              onPressed: (ctx) {
                final Transaction transactionCopy = Transaction(
                    date: transaction.date,
                    category: transaction.category,
                    amount: transaction.amount,
                    type: transaction.type);
                transactionController.deleteTransaction(transaction);
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    backgroundColor: AppTheme.darkGray,
                    content: const Text('Transaction Deleted'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          transactionController.addTransaction(transactionCopy);
                        }),
                  ));
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            )
          ]),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
                horizontal: BorderSide(color: Color(0x22000000), width: .5))),
        child: InkWell(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddTransaction(
              transaction: transaction,
            );
          })),
          onLongPress: () {
            if (enableSlide) {
              Util.showSnackbar(context, 'Slide transaction to delete');
            }
          },
          child: Row(
            children: [
              TileDateView(transaction.date),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (transaction.description != null &&
                        transaction.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          transaction.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.darkGray),
                        ),
                      ),
                  ],
                ),
              ),
              Text('\u{20B9} ${transaction.amount.toString()}',
                  style: TextStyle(
                      color: textColors[transaction.type.index],
                      fontSize: 14,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}

class TileDateView extends StatelessWidget {
  final DateTime date;
  final DateTime today = DateTime.now();
  TileDateView(this.date, {Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: getDateString(today) == getDateString(date)
          ? BoxDecoration(
              color: const Color(0x00E0E0E0),
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(5))
          : BoxDecoration(
              color: const Color(0xfff0f0f0),
              borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date.day.toString(),
              style: GoogleFonts.orbitron(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3)),
          const SizedBox(
            width: 8,
          ),
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: GoogleFonts.orbitron(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  String getDateString(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
