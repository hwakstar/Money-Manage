import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/constants/app_theme.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/models/category.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/screens/category/dialog_add_cateory.dart';
import 'package:money_manager/widgets/circular_button.dart';

import 'package:toggle_switch/toggle_switch.dart';

class AddTransaction extends StatefulWidget {
  final Transaction? transaction;

  const AddTransaction({this.transaction, Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TransactionController transactionManager = Get.find();
  final _formKey = GlobalKey<FormState>();
  late bool isEdit;
  DateTime date = DateTime.now();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final transactionTypes = ['Income', 'Expense'];
  TransactionType transactionType = TransactionType.expense;

  @override
  void initState() {
    if (widget.transaction != null) {
      final Transaction transaction = widget.transaction!;
      date = transaction.date;
      categoryController.text = transaction.category;
      amountController.text = transaction.amount.toString();
      descriptionController.text = transaction.description ?? '';
      transactionType = transaction.type;
    }
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    _amountFocus.dispose();
    _categoryFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    isEdit = widget.transaction != null;
    dateController.text = getFormatedDate(date);
    return Scaffold(
      backgroundColor: const Color(0xFFF3f3f3),
      appBar: AppBar(
        title: Text(isEdit
            ? transactionTypes[transactionType.index]
            : 'Add Transaction'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stack(children: [
          ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 55),
              children: [
                const SizedBox(height: 10),
                if (!isEdit) _buildToggleSwitch(size),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(boxShadow: const [
                    BoxShadow(color: Colors.black),
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 0,
                      blurRadius: 4,
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          pickDate();
                        },
                        decoration: const InputDecoration(
                          prefixIcon:
                              Icon(Icons.calendar_month, color: Colors.blue),
                          label: Text('Date'),
                        ),
                      ),
                      TextFormField(
                        controller: categoryController,
                        focusNode: _categoryFocus,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                        onTap: () {
                          pickCategory(transactionType.index);
                        },
                        autofocus: !isEdit,
                        validator: (category) =>
                            category != null && category.isEmpty
                                ? 'Enter  Category'
                                : null,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.category,
                            color: Colors.blue,
                          ),
                          label: Text('Category'),
                        ),
                      ),
                      TextFormField(
                        controller: amountController,
                        focusNode: _amountFocus,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(_amountFocus, _descriptionFocus);
                        },
                        validator: (amount) =>
                            amount != null && double.tryParse(amount) == null
                                ? 'Enter Amount'
                                : null,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.currency_rupee,
                              color: Colors.blue,
                            ),
                            label: Text('Amount'),
                            hintText: ' 0'),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        focusNode: _descriptionFocus,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 30,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.edit_note,
                              color: Colors.blue,
                            ),
                            label: Text('Note'),
                            counterText: ''),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ]),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              color: Colors.white,
              child: Column(
                children: [
                  const Divider(thickness: 1.5, height: 1.5),
                  Row(
                    children: [
                      Visibility(
                        visible: !isEdit,
                        child: SizedBox(
                          height: 40,
                          child: TextButton(
                            autofocus: false,
                            onPressed: () {
                              save(close: false);
                            },
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25)),
                            child: const Text('SAVE & ADD ANOTHER'),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            save(close: true);
                          },
                          style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25)),
                          child: const Text('SAVE'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _buildToggleSwitch(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleSwitch(
          minWidth: size.width * .35,
          minHeight: 28,
          cornerRadius: 25.0,
          activeBgColors: const [
            [Colors.white, Color(0xFFEBFFE3)],
            [Colors.white, Color(0xFFFCE5E5)]
          ],
          activeFgColor: Colors.black,
          inactiveBgColor: AppTheme.lihtGray,
          inactiveFgColor: Colors.black,
          customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
          borderColor: const [AppTheme.lihtGray],
          initialLabelIndex: transactionType.index,
          totalSwitches: 2,
          labels: transactionTypes,
          radiusStyle: true,
          onToggle: (index) {
            transactionType =
                index == 1 ? TransactionType.expense : TransactionType.income;
            categoryController.clear();
          },
        ),
      ],
    );
  }

  pickCategory(int type) async {
    String? newcat = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => CategorySheet(type: type));

    if (newcat != null) {
      categoryController.text = newcat;
      _fieldFocusChange(_categoryFocus, _amountFocus);
    }
  }

  save({required bool close}) {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      Transaction transaction = Transaction(
          date: date,
          category: categoryController.text,
          amount: double.parse(amountController.text),
          type: transactionType,
          description: descriptionController.text);
      if (isEdit) {
        transactionManager.updateTransaction(
            widget.transaction!.key, transaction);
      } else {
        transactionManager.addTransaction(transaction);
      }
      if (close) {
        Navigator.pop(context);
      } else {
        categoryController.clear();
        amountController.clear();
        descriptionController.clear;
        FocusScope.of(context).requestFocus(_categoryFocus);
        pickCategory(transactionType.index);
      }
    }
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != date) {
      date = picked;
      dateController.text = getFormatedDate(date);
    }
  }

  String getFormatedDate(DateTime dateTime) =>
      DateTime.now().year == dateTime.year
          ? DateFormat('d MMM, E').format(date)
          : DateFormat('d MMM y, E').format(date);
}

class CategorySheet extends StatefulWidget {
  const CategorySheet({
    Key? key,
    required this.type,
  }) : super(key: key);
  final int type;

  @override
  State<CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .45,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFF777777), width: .5)),
          boxShadow: [
            BoxShadow(),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                CircularButton(
                  icon: Icons.add,
                  size: 30,
                  onPressed: () {
                    showDialog(
                            context: context,
                            builder: (context) =>
                                AddCateoryDialog(type: widget.type))
                        .whenComplete(() {
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
              child: GetBuilder<CategoryController>(builder: ((controller) {
            List<Category> categories =
                CategoryController().getActiveCategories(widget.type);
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 8 / 1.75,
                ),
                itemCount: categories.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        border: Border.all(color: Colors.grey, width: .25)),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pop(categories[index].categoryName);
                      },
                      child: Center(
                        child: Text(
                          categories[index].categoryName,
                        ),
                      ),
                    ),
                  );
                });
          })))
        ],
      ),
    );
  }
}
