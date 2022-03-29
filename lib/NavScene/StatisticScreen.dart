import 'package:expense_app/StatisticScreenComponent/GraphScreen.dart';
import 'package:expense_app/StatisticScreenComponent/ReportScreen.dart';
import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_graphItem.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyStatisticScreen extends StatefulWidget {
  const MyStatisticScreen({Key? key}) : super(key: key);

  @override
  State<MyStatisticScreen> createState() => _MyStatisticScreenState();
}

class _MyStatisticScreenState extends State<MyStatisticScreen>
    with SingleTickerProviderStateMixin {
  List<Budget> budgetList = <Budget>[];
  List<Saving> savingList = <Saving>[];
  List<Event> eventList = <Event>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: initializeList(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _buildLoadingProgress(context); //when loading
          } else if (snapshot.hasError) {
            //when error occur
          } else {
            //when complete
            return _buildContent(context);
          }
          return _buildContent(context);
        });
  }

  Widget _buildLoadingProgress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                strokeWidth: 4.0,
              ),
              Text("Loading"),
            ]),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            child: _buildGraph(context),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(0),
              child: _buildReport(context),
            )),
      ],
    );
  }

  
  Widget _buildGraph(BuildContext context) {
    return MyGraphScreen(passedBudgetList: budgetList, passedSavingList: savingList, passedEventList: eventList,);
  }


  Widget _buildReport(BuildContext context) {
    return MyReportScreen(passedBudgetList: budgetList, passedSavingList: savingList, passedEventList: eventList,);
  }

  void pass() {}

  Future<bool> initializeList() async {
    if (kIsWeb) {
      initializeTempList();
      return true;
    } else {
      MySQFliteController mySQFController = MySQFliteController();
      budgetList = await mySQFController.retrieveBudgetList();
      savingList = await mySQFController.retrieveSavingList();
      eventList = await mySQFController.retrieveEventList();
      Future.delayed(const Duration(seconds: 10));
      return true;
    }
  }

  void initializeTempList() {
    for (int i = 0; i < 10; i++) {
      Budget b = Budget(
          id: i + 1,
          tag: "Budget Tag" + i.toString(),
          amount: (i * 10),
          dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()));
      Saving s = Saving(
          id: i + 1,
          tag: "Saving Tag" + i.toString(),
          amount: (i * 2),
          dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()));
      Event e = Event(
          id: i + 1,
          title: "Event Title" + i.toString(),
          dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          duration: i.toString() + " hour(s)");
      budgetList.add(b);
      savingList.add(s);
      eventList.add(e);
      setState(() {
        pass();
      });
    }
  }


}
