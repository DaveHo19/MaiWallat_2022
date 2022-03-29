import 'dart:collection';
import 'dart:math';

import 'package:expense_app/component/_enumList.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/component/_itemComponent.dart';

class MyDashboardScreen extends StatefulWidget {
  const MyDashboardScreen({Key? key}) : super(key: key);
  @override
  State<MyDashboardScreen> createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen>
    with SingleTickerProviderStateMixin {
  //var myBudget = getDBBudgetList();
  late TabController tabController;
  List<Budget> budgetList = <Budget>[];
  List<Saving> savingList = <Saving>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
    return 
      Container(
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
           Container(
            width: MediaQuery.of(context).size.width ,
            padding: const EdgeInsets.all(0.0),
            child: _buildUserBanner(context),
          // ),
        ),
        Expanded(
          flex: 1,
          child: 
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            child: _buildMainBanner(context),
          ),
        ),
        Expanded(
          flex: 2,
        child: 
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            child: _buildRecentHistoryView(context),
          ),
        )
      ],
    );
  }

  Widget _buildUserBanner(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: _buildUserBannerContent(context),
      ),
    );
  }

  Widget _buildUserBannerContent(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          generateGreetingTime(),
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          getAppellation(),
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Icon(
        generateDayIcon(),
        size: 25,
      ),
    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Usage",
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat("yyyy-MM-dd").format(DateTime.now()),
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          getTodaySpend().toStringAsFixed(2),
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      leading: const Icon(
        Icons.payment,
        size: 25,
      ),
    );
  }

  Widget _buildRecentHistoryView(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: _buildRecentHistoryContent(context),
      ),
    );
  }

  Widget _buildRecentHistoryContent(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "Recent History",
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: ListTile(
        title: _buildHistoryTabHeader(context),
        subtitle: _buildHistoryTabContent(context),
      ),
    );
  }

  Widget _buildHistoryTabHeader(BuildContext context) {
    return TabBar(
        controller: tabController,
        labelColor: Colors.orangeAccent,
        tabs: const [
          Tab(
            text: "Usage",
          ),
          Tab(
            text: "Saving",
          ),
        ]);
  }

  Widget _buildHistoryTabContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 10 * 3,
      padding: const EdgeInsets.all(0.0),
      child: TabBarView(
        controller: tabController,
        children: [
          _buildRecentItemList(ItemEnum.budget),
          _buildRecentItemList(ItemEnum.saving),
        ],
      ),
    );
  }

  Widget _buildRecentItemList(ItemEnum type) {
    List<ItemComponent> iList = <ItemComponent>[];
    iList = getItemComponentList(type);
    return ListView.builder(
        itemCount: iList.isEmpty
            ? 0
            : iList.length > 10
                ? 10
                : iList.length,
        itemBuilder: (context, i) {
          return _buildListItemRow(iList[i]);
        });
  }

  Widget _buildListItemRow(var item) {
    return ListTile(
      title: //Text(activity.title)
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.title),
          Text(item.dateTime),
        ],
      ),
      subtitle: Text(item.description),
    );
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
          amount: (i * 15),
          dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()));
      budgetList.add(b);
      savingList.add(s);
      setState(() {
        pass();
      });
    }
  }

  List<ItemComponent> getItemComponentList(ItemEnum type) {
    List<ItemComponent> list = <ItemComponent>[];
    if (type == ItemEnum.budget) {
      budgetList.forEach((element) {
        list.add(element.toItemComponent());
      });
    } else if (type == ItemEnum.saving) {
      savingList.forEach((element) {
        list.add(element.toItemComponent());
      });
    }
    return list.reversed.toList();
  }

  double getTotalSpend() {
    double total = 0;
    if (budgetList.isNotEmpty) {
      budgetList.forEach((element) {
        total += element.amount;
      });
    }
    return total;
  }

  double getTodaySpend() {
    double todaySpend = 0;
    if (budgetList.isNotEmpty) {
      String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      budgetList.forEach((element) {
        if (element.dateTime == todayDate) {
          todaySpend += element.amount;
        }
      });
    }
    return todaySpend;
  }

  Future<List<Budget>> getDBBudgetList() async {
    MySQFliteController mySQF = MySQFliteController();
    List<Budget> list = await mySQF.retrieveBudgetList();
    return list;
  }

  Future<List<Saving>> getDBSavingList() async {
    MySQFliteController mySQF = MySQFliteController();
    List<Saving> list = await mySQF.retrieveSavingList();
    return list;
  }

  Future<List<ItemComponent>> getItemList(ItemEnum type) async {
    var tList;
    if (type == ItemEnum.budget) {
      tList = await getDBBudgetList();
    } else {
      tList = await getDBSavingList();
    }
    List<ItemComponent> list = <ItemComponent>[];
    tList.forEach((element) {
      list.add(element.toItemComponent());
    });
    return list;
  }

  String generateGreetingTime() {
    int hour = int.parse(DateFormat("HH").format(DateTime.now()));
    String greeting = "";
    if (hour < 12 && hour >= 5) {
      greeting = "Good Morning!";
    } else if (hour < 17 && hour >= 12) {
      greeting = "Good Afternoon!";
    } else if (hour < 5 && hour >= 17) {
      greeting = "Good Evening!";
    } else {
      greeting = "Good day!";
    }

    return greeting;
  }

  IconData generateDayIcon() {
    int hour = int.parse(DateFormat("HH").format(DateTime.now()));
    if (hour < 18 && hour >= 6) {
      return Icons.brightness_high;
    } else if (hour < 6 && hour >= 18) {
      return Icons.bedtime;
    } else {
      return Icons.brightness_high;
    }
  }

  String getAppellation() {

    List<String> appellation = <String>[ "Human", "Stranger", "Dear", "Newcomer", 
                                         "User", "Guest", "Friend", "Unknown",
                                         "Fellow", "Soul", "Creature", "Legend"];
    var random = Random();
    String name = appellation[random.nextInt(appellation.length)];
    return name;
  }
}
