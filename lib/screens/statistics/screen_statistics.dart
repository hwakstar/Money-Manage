import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_manager/controllers/monthly_chart_controller.dart';
import 'package:money_manager/controllers/yearly_chart_contoller.dart';
import 'package:money_manager/screens/statistics/monthly_chart.dart';
import 'package:money_manager/screens/statistics/yearly_chart.dart';
import 'package:money_manager/widgets/menu_widget.dart';

class ScreenStatistics extends StatefulWidget {
  const ScreenStatistics({Key? key}) : super(key: key);
  @override
  State<ScreenStatistics> createState() => _ScreenStatisticsState();
}

class _ScreenStatisticsState extends State<ScreenStatistics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MonthlyChartContollrt monthChartController = Get.find();
  final YearlyChartContoller yearChartController = Get.find();
  final DateTime now = DateTime.now();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    final initDateS = DateTime(now.year, now.month, 1);
    final initDateE = DateTime(initDateS.year, initDateS.month + 1, 1);
    monthChartController.initialize(initDateS, initDateE);
    yearChartController.initialize(DateTime(now.year), DateTime(now.year + 1));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: const MenuWidget(),
          title: const Text('Statistics'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade300,
                Colors.grey.shade400,
                Colors.grey.shade500,
              ],
            ),
          ),
          width: double.infinity,
          child: Column(children: [
            Container(
              height: 35,
              margin: const EdgeInsets.only(top: 25, bottom: 15),
              width: size.width * .8,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: .5,
                      blurRadius: .5,
                      offset: const Offset(0, .5),
                    ),
                    const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-.5, -.5),
                        blurRadius: .5,
                        spreadRadius: .5),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade200,
                    ],
                  ),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Monthly'),
                  Tab(text: 'Yearly'),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MonthlyChart(),
                  YearlyChart(),
                ],
              ),
            )
          ]),
        ));
  }
}
