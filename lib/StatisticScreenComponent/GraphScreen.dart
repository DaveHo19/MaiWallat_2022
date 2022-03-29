import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_graphItem.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class MyGraphScreen extends StatefulWidget {
  const MyGraphScreen({
    Key? key,
    required this.passedBudgetList,
    required this.passedSavingList,
    required this.passedEventList,
  }) : super(key: key);

  final List<Budget> passedBudgetList;
  final List<Saving> passedSavingList;
  final List<Event> passedEventList;
  @override
  State<MyGraphScreen> createState() => _MyGraphScreenState();
}

class _MyGraphScreenState extends State<MyGraphScreen> {
  List<GraphItem> graphItemList = <GraphItem>[];
  int selectedItemTypeIndex = 0;
  List<String> itemList = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    initialItemList();
    generateGraphItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            Expanded(flex: 1, child: _buildItemRow(context)),
            Expanded(flex: 2, child: _buildGraphContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () => setState(() {
            if (selectedItemTypeIndex > 0) {
              selectedItemTypeIndex--;
            } else {
              selectedItemTypeIndex = itemList.length - 1;
            }
            generateGraphItem();
          }),
        ),
        Text(itemList.elementAt(selectedItemTypeIndex)),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: () => setState(() {
            if (selectedItemTypeIndex < itemList.length - 1) {
              selectedItemTypeIndex++;
            } else {
              selectedItemTypeIndex = 0;
            }
            generateGraphItem();
          }),
        ),
      ],
    );
  }

  Widget _buildGraphContent() {
    return Container(
      padding: const EdgeInsets.all(0),
      child: SfCartesianChart(
          primaryXAxis: DateTimeCategoryAxis(),
          series: <ChartSeries>[
            LineSeries<GraphItem, DateTime>(
              dataSource: graphItemList,
              xValueMapper: (GraphItem data, _) => data.dateTime,
              yValueMapper: (GraphItem data, _) => data.amount,
            )
          ]),
    );
  }

  void initialItemList() {
    itemList.add("Budget");
    itemList.add("Saving");
    itemList.add("Event");
  }


  void generateGraphItem() {
    graphItemList.clear();
    double amtDay1 = 0,
        amtDay2 = 0,
        amtDay3 = 0,
        amtDay4 = 0,
        amtDay5 = 0,
        amtDay6 = 0,
        amtDay7 = 0;
    DateTime today = DateTime.now();

    String day1 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 1)));
    String day2 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 2)));
    String day3 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 3)));
    String day4 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 4)));
    String day5 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 5)));
    String day6 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 6)));
    String day7 = DateFormat("yyyy-MM-dd")
        .format(today.subtract(Duration(days: today.weekday - 7)));

    //budget
    if (selectedItemTypeIndex == 0) {
      widget.passedBudgetList.forEach((element) {
        if (element.dateTime == day1) {
          amtDay1 += element.amount;
        }
        if (element.dateTime == day2) {
          amtDay2 += element.amount;
        }
        if (element.dateTime == day3) {
          amtDay3 += element.amount;
        }
        if (element.dateTime == day4) {
          amtDay4 += element.amount;
        }
        if (element.dateTime == day5) {
          amtDay5 += element.amount;
        }
        if (element.dateTime == day6) {
          amtDay6 += element.amount;
        }
        if (element.dateTime == day7) {
          amtDay7 += element.amount;
        }
      });
    }
    //saving
    if (selectedItemTypeIndex == 1) {
            widget.passedSavingList.forEach((element) {
        if (element.dateTime == day1) {
          amtDay1 += element.amount;
        }
        if (element.dateTime == day2) {
          amtDay2 += element.amount;
        }
        if (element.dateTime == day3) {
          amtDay3 += element.amount;
        }
        if (element.dateTime == day4) {
          amtDay4 += element.amount;
        }
        if (element.dateTime == day5) {
          amtDay5 += element.amount;
        }
        if (element.dateTime == day6) {
          amtDay6 += element.amount;
        }
        if (element.dateTime == day7) {
          amtDay7 += element.amount;
        }
      });
    }
    //event
    if (selectedItemTypeIndex == 2) {
      widget.passedEventList.forEach((element) {
        if (element.dateTime == day1) {
          amtDay1++;
        }
        if (element.dateTime == day2) {
          amtDay2++;
        }
        if (element.dateTime == day3) {
          amtDay3++;
        }
        if (element.dateTime == day4) {
          amtDay4++;
        }
        if (element.dateTime == day5) {
          amtDay5++;
        }
        if (element.dateTime == day6) {
          amtDay6++;
        }
        if (element.dateTime == day7) {
          amtDay7++;
        }
      });
    }
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 1)), amount: amtDay1));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 2)), amount: amtDay2));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 3)), amount: amtDay3));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 4)), amount: amtDay4));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 5)), amount: amtDay5));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 6)), amount: amtDay6));
    graphItemList.add(GraphItem(dateTime: today.subtract(Duration(days: today.weekday - 7)), amount: amtDay7));

  }
}
