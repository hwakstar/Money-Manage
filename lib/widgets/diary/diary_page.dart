import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/diary_controller.dart';
import 'package:money_manager/widgets/circular_button.dart';
import 'package:money_manager/widgets/diary/page_layout.dart';

class DiaryPage extends StatefulWidget {
  DiaryPage({Key? key, required this.date}) : super(key: key);
  final diaryController = Get.put(DiaryController());
  final DateTime date;
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late DiaryController controller;
  @override
  void initState() {
    /*SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Color(0xff26384f)));*/
    init();
    controller = widget.diaryController;
    controller.initialize();
    super.initState();
  }

  init() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actionsIconTheme: const IconThemeData(color: Color(0xFF324149)),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          leading: IconButton(
              onPressed: () {
                DrawerScaffold.currentController(context).toggle();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              )),
          elevation: 0,
          scrolledUnderElevation: 5,
          actions: [
            IconButton(
                onPressed: () {
                  pickDate();
                },
                icon: const Icon(Icons.calendar_month, color: Colors.black)),
            const SizedBox(width: 100)
            // SmallDateView(widget.diaryController.selDate)
          ]),
      body: SingleChildScrollView(
        child: GetBuilder<DiaryController>(builder: (controller) {
          final DateTime date = controller.selDate;
          final incomeList = controller.incomeTransactions;

          final expList = controller.expTransactions;
          return PageLayout(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: double.infinity, minHeight: _getPageMinHeight()),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            color: Colors.white,
                            child: DateView(
                              date,
                              onNext: () {
                                DateTime nextDay =
                                    date.add(const Duration(days: 1));
                                controller.goToDate(nextDay);
                              },
                              onPrev: () {
                                DateTime prevDay =
                                    date.subtract(const Duration(days: 1));
                                controller.goToDate(prevDay);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Dtitle(
                            title: 'Total Income',
                            trailing: '\u{20B9} ${controller.totalIncome}',
                            trailingColor:
                                const Color.fromARGB(255, 30, 161, 34)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: incomeList.length,
                          itemBuilder: (context, index) {
                            return Dline(
                                title: incomeList[index].category,
                                trailing: incomeList[index].amount.toString());
                          },
                        ),
                        const BlankLine(),
                        Dtitle(
                            title: 'Total Expense',
                            trailing: '\u{20B9} ${controller.totalExpense}',
                            trailingColor: Colors.red),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expList.length,
                          itemBuilder: (context, index) {
                            return Dline(
                                title: expList[index].category,
                                trailing: expList[index].amount.toString());
                          },
                        ),
                        const BlankLine(),
                        Dtitle(
                          title: 'Balance',
                          trailing: '\u{20B9} ${controller.dayBalance}',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  pickDate() async {
    DateTime date = controller.selDate;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.selDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != date) {
      controller.goToDate(picked);
    }
  }

  _getPageMinHeight() =>
      MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.bottom -
      MediaQuery.of(context).padding.top;
}

class Dline extends StatelessWidget {
  const Dline({
    Key? key,
    required this.title,
    required this.trailing,
  }) : super(key: key);
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.end,
              style: GoogleFonts.arvo(fontSize: 13),
            ),
            const Spacer(),
            Text(
              trailing,
              textAlign: TextAlign.end,
              style: GoogleFonts.arvo(fontSize: 13),
            )
          ],
        ));
  }
}

class Dtitle extends StatelessWidget {
  const Dtitle({
    Key? key,
    required this.title,
    required this.trailing,
    this.trailingColor = Colors.black,
  }) : super(key: key);
  final String title;
  final String trailing;
  final Color trailingColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        child: Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.end,
              style: GoogleFonts.arvo(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(trailing,
                textAlign: TextAlign.end,
                style: GoogleFonts.arvo(
                    fontWeight: FontWeight.bold, color: trailingColor))
          ],
        ));
  }
}

class BlankLine extends StatelessWidget {
  const BlankLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

class SmallDateView extends StatelessWidget {
  final DateTime date;
  const SmallDateView(this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE').format(date).toUpperCase(),
            style: GoogleFonts.orbitron(
                fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat.d().format(date),
            style: GoogleFonts.orbitron(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 2),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: GoogleFonts.orbitron(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }
}

class DateView extends StatelessWidget {
  final DateTime date;
  const DateView(this.date,
      {Key? key, required this.onNext, required this.onPrev})
      : super(key: key);
  final Function onNext;
  final Function onPrev;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 2,
      ),
      Text(
        DateFormat('EEEE').format(date).toUpperCase(),
        style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.w800),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          const SizedBox(width: 5),
          CircularButton(
              onPressed: () {
                onPrev();
              },
              icon: Icons.arrow_back_ios),
          const Spacer(),
          Text(
            DateFormat.d().format(date),
            style: GoogleFonts.orbitron(
                color: Colors.red,
                fontSize: 40,
                fontWeight: FontWeight.w800,
                letterSpacing: 3),
          ),
          const Spacer(),
          CircularButton(
              onPressed: () {
                onNext();
              },
              icon: Icons.arrow_forward_ios),
          const SizedBox(width: 5),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        DateFormat('MMM').format(date).toUpperCase(),
        style: GoogleFonts.orbitron(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800),
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
        DateFormat.y().format(date),
        style: GoogleFonts.averiaLibre(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    ]);
  }
}

class DateFormatted {
  final DateTime date;
  String? day;
  DateFormatted(this.date) {
    day = DateFormat.d().format(date);
  }
}
