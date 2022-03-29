import 'package:expense_app/ItemScene/ViewItemListScreen.dart';
import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/component/_enumList.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyExpensesScreen extends StatefulWidget {
  const MyExpensesScreen({Key? key}) : super(key: key);

  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}

class _MyExpensesScreenState extends State<MyExpensesScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Budget> budgetList = <Budget>[];
  List<Event> eventList = <Event>[];
  List<Saving> savingList = <Saving>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeList();
  }
  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(4.0),
          child: _buildCalendar(context),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(4.0),
            child: FutureBuilder<bool>(
              future: initializeList(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                 return _buildDateDetails(context);
              }
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildCalendar(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 01, 01),
        lastDay: DateTime.utc(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerStyle:
            const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildDateDetails(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: ListTile(
          title: _buildDetailTitle(context),
          subtitle: _buildDetailList(context),
        ),
    );
  }

  Widget _buildDetailTitle(BuildContext context){
    return const Text(
                    "Date Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ));
  }
  Widget _buildDetailList(BuildContext context){
    List<ListTile> iList = <ListTile>[];
    iList = generateSelectedDateItem();
    
    return RefreshIndicator(
      onRefresh: refreshContent,
      child: ListView.builder(
        itemCount: iList.isEmpty ? 0 : iList.length,
        itemBuilder: (context, i){
          return iList.elementAt(i);
        }),
    );
  }
 
  Future<bool> initializeList() async {
    if (kIsWeb) {
      budgetList.clear();
      savingList.clear();
      eventList.clear();
      initializeTempList();
      return true;
    } else {
      MySQFliteController mySQFController = MySQFliteController();
      budgetList = await mySQFController.retrieveBudgetList();
      savingList = await mySQFController.retrieveSavingList();
      eventList = await mySQFController.retrieveEventList();
      Future.delayed(Duration(seconds: 10));
      return true;
    }
  }

  List<ListTile> generateSelectedDateItem() {
    List<ListTile> items = <ListTile>[];
    
    String selectedDate = DateFormat("yyyy-MM-dd").format(_focusedDay);
    double budgetAmount = 0, savingAmount = 0, eventQty = 0;

    if (budgetList.isNotEmpty) {
      budgetList.forEach((element) {
        if (element.dateTime == selectedDate) {
          budgetAmount += element.amount;
        }
      });
    }

    if (savingList.isNotEmpty) {
      savingList.forEach((element) {
        if (element.dateTime == selectedDate) {
          savingAmount += element.amount;
        }
      });
    }
    if (eventList.isNotEmpty) {
      eventList.forEach((element) {
        if (element.dateTime == selectedDate) {
          eventQty++;
        }
      });
    }

    ListTile budgetTile = ListTile(
      title: const Text("My Usages"),
      subtitle: Text("Amount: " + budgetAmount.toStringAsFixed(2)),
      onTap: () => {
        goToViewItemListScreen(ItemEnum.budget),
      }
    );
    ListTile savingTile = ListTile(
      title: const Text("My Savings"),
      subtitle: Text("Amount: " + savingAmount.toStringAsFixed(2)),
      onTap: () => {
        goToViewItemListScreen(ItemEnum.saving),
      }
    );
    ListTile eventTile = ListTile(
      title: const Text("My Events"),
      subtitle: Text("Quantity: " + eventQty.toString()),
      onTap: () => {
        goToViewItemListScreen(ItemEnum.event),
      }
    );
    items.add(budgetTile);
    items.add(savingTile);
    items.add(eventTile);
    return items;
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

  void pass() {}

  Future<void> refreshContent(){
    setState(() {
      initializeList();
    });
    return Future.value(null);
  }

  void goToViewItemListScreen(ItemEnum iType){
        Navigator.push( context, MaterialPageRoute(builder: (context) => 
        MyViewItemListScreen(selectedDate: DateFormat("yyyy-MM-dd").format(_focusedDay), itemType: iType)),);
  }
  // void goToViewBudgetListDetailScreen() {
  //   Navigator.push( context, MaterialPageRoute(builder: (context) => 
  //       MyViewItemListScreen(selectedDate: DateFormat("yyyy-MM-dd").format(_focusedDay), itemType: ItemEnum.budget )),);
  // }

  // void goToViewSavingListDetailScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => MyViewSavingListScreen(
  //               dateTime: _focusedDay,
  //             )),
  //   );
  // }

  // void goToViewEventListDetailScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => MyViewEventListScreen(
  //               dateTime: _focusedDay,
  //             )),
  //   );
  // }
}
