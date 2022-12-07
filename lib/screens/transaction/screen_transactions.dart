import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/transaction/add_transaction.dart';
import 'package:money_manager/widgets/empty_view.dart';

import 'package:money_manager/widgets/tile_transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  final TransactionController transactionController = Get.find();
  final scrollController = ScrollController();
  bool showFAB = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          showFAB) {
        setState(() {
          showFAB = false;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !showFAB) {
        setState(() {
          showFAB = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFF3f3f3),
        floatingActionButton: AnimatedSlide(
          offset: showFAB ? Offset.zero : const Offset(0, 1.5),
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: showFAB ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTransaction();
                }));
              },
              tooltip: 'New transaction',
              child: const Icon(Icons.add),
            ),
          ),
        ),
        body: GetBuilder<TransactionController>(
          builder: (controller) {
            // if (controller.box.isEmpty) {
            //   return const Center(
            //     child: Text('No transactions Found'),
            //   );
            // }
            if (controller.filterdList.isEmpty) {
              return const EmptyView(
                  icon: Icons.receipt_long, label: 'No transactions found');
            }
            return SlidableAutoCloseBehavior(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  controller: scrollController,
                  itemCount: controller.filterdList.length,
                  itemBuilder: (context, index) {
                    Transaction currItem = controller.filterdList[index];
                    return TransactionTile(
                      transaction: currItem,
                      transactionController: transactionController,
                    );
                  }),
            );
          },
        ));
  }
}
