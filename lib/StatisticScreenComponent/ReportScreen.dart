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

class MyReportScreen extends StatefulWidget {
  const MyReportScreen({
    Key? key,
    required this.passedBudgetList,
    required this.passedSavingList,
    required this.passedEventList,
  }) : super(key: key);

  final List<Budget> passedBudgetList;
  final List<Saving> passedSavingList;
  final List<Event> passedEventList;
  @override
  State<MyReportScreen> createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  final TextEditingController textSDateController = TextEditingController();
  final TextEditingController textLDateController = TextEditingController();

  List<String> filterList = <String>[];
  List<String> itemList = <String>[];

  int selectedItemTypeIndex = 0;
  int selectedFilterTypeIndex = 0;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _sFocusedDay = DateTime.now().subtract(Duration(days: 1));
  DateTime? _sSelectedDay;
  DateTime _lFocusedDay = DateTime.now();
  DateTime? _lSelectedDay;

  @override
  void initState() {
    // TODO: implement initState
    initialItemList();
    initialFilterList();
    textSDateController.text = DateFormat("yyyy-MM-dd").format(_sFocusedDay);
    textLDateController.text = DateFormat("yyyy-MM-dd").format(_lFocusedDay);
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
            Expanded(flex: 1, child: _buildFilterRow(context)),
            //Expanded(flex: 1, child: IconButton(icon: const Icon(Icons.question_mark), onPressed: debug))
            Expanded(flex: 2, child: _buildReportContent(context)),
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
          }),
        ),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text(generateSecondHeader(),
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                style: const TextStyle(
                  fontSize: 16,
                  
                ))),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () => setState(() {
              if (selectedFilterTypeIndex < filterList.length - 1) {
                selectedFilterTypeIndex++;
              } else {
                selectedFilterTypeIndex = 0;
              }
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: (selectedFilterTypeIndex == filterList.length - 1)
              ? IconButton(
                  icon: const Icon(Icons.wysiwyg),
                  onPressed: openRangeFilterDialog)
              : Container(),
        ),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context) {
    return ListTile(
      title: Text(getReportTitle()),
      subtitle: Text(
        getReportResult(),
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        ),
    );
  }

  void initialFilterList() {
    filterList.add("Weekly");
    filterList.add("Monthly");
    filterList.add("Pass 7 days");
    filterList.add("Range from:");
  }

  void initialItemList() {
    itemList.add("Budget");
    itemList.add("Saving");
    itemList.add("Event");
  }

  String generateSecondHeader() {
    String header = "";
    header += "\tMode: ";
    header += (selectedFilterTypeIndex != filterList.length - 1)
        ? filterList.elementAt(selectedFilterTypeIndex)
        : DateFormat("yyyy-MM-dd").format(_sFocusedDay) +
            " - " +
            DateFormat("yyyy-MM-dd").format(_lFocusedDay);
    return header;
  }

  void openRangeFilterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => (AlertDialog(
            title: const Text("Date Range"),
            content: Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    _buildSDateSelectionField(context),
                    _buildLDateSelectionField(context),
                  ],
                )))));
  }

  Widget _buildSDateSelectionField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: GFIconButton(
            icon: const Icon(Icons.edit_calendar_outlined,
                color: Colors.white, size: GFSize.SMALL),
            //color: Colors.deepOrangeAccent,
            color: Colors.black,
            shape: GFIconButtonShape.standard,
            size: GFSize.LARGE,
            onPressed: callStartCalendar,
          ),
          border: const OutlineInputBorder(),
          labelText: "Date",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        controller: textSDateController,
        readOnly: true,
      ),
    );
  }

  Widget _buildLDateSelectionField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: GFIconButton(
            icon: const Icon(Icons.edit_calendar_outlined,
                color: Colors.white, size: GFSize.SMALL),
            //color: Colors.deepOrangeAccent,
            color: Colors.black,
            shape: GFIconButtonShape.standard,
            size: GFSize.LARGE,
            onPressed: callLastCalendar,
          ),
          border: const OutlineInputBorder(),
          labelText: "Date",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        controller: textLDateController,
        readOnly: true,
      ),
    );
  }

  void callStartCalendar() {
    showDialog(
        context: context,
        builder: (BuildContext context) => (AlertDialog(
              title: const Text('First Day'),
              content: Container(
                width: 350,
                height: 400,
                padding: const EdgeInsets.all(4.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 01, 01),
                  lastDay: DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  focusedDay: _sFocusedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  selectedDayPredicate: (day) {
                    return isSameDay(_sSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_sSelectedDay, selectedDay)) {
                      setState(() {
                        _sSelectedDay = selectedDay;
                        _sFocusedDay = focusedDay;
                        textSDateController.text =
                            DateFormat("yyyy-MM-dd").format(selectedDay);
                        Navigator.pop(context);
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
                    _sFocusedDay = focusedDay;
                  },
                ),
              ),
            )));
  }

  void callLastCalendar() {
    showDialog(
        context: context,
        builder: (BuildContext context) => (AlertDialog(
              title: const Text('Last Day'),
              content: Container(
                width: 350,
                height: 400,
                padding: const EdgeInsets.all(4.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 01, 01),
                  lastDay: DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  focusedDay: _lFocusedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  selectedDayPredicate: (day) {
                    return isSameDay(_lSelectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_lSelectedDay, selectedDay)) {
                      if (focusedDay.isBefore(_sFocusedDay) ||
                          isSameDay(focusedDay, _sFocusedDay)) {
                        showErrorDialog();
                      } else {
                        setState(() {
                          _lSelectedDay = selectedDay;
                          _lFocusedDay = focusedDay;
                          textLDateController.text = DateFormat("yyyy-MM-dd").format(selectedDay);
                          Navigator.pop(context);
                        });
                      }
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
                    _lFocusedDay = focusedDay;
                  },
                ),
              ),
            )));
  }

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => (AlertDialog(
            title: const Text("Error"),
            content: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(4.0),
              child: const Text(
                  "Last Day cannot earlier than or same with First Day for Range!!!"),
            ))));
  }

  String getReportTitle(){
    DateTime today = DateTime.now();
    String title = "";

    //weekly
    if (selectedFilterTypeIndex == 0){
      DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
      DateTime lastDayOfWeek = today.add(Duration(days: DateTime.daysPerWeek - today.weekday));
      title += "From " + DateFormat("yyyy-MM-dd").format(firstDayOfWeek) + " to " + DateFormat("yyyy-MM-dd").format(lastDayOfWeek);
    }
    //monthly
    if (selectedFilterTypeIndex == 1){
      DateTime firstDayOfMonth = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
      DateTime lastDayOfMonth = DateTime.utc(DateTime.now().year, DateTime.now().month+1).subtract(const Duration(days: 1));
      title += "From " + DateFormat("yyyy-MM-dd").format(firstDayOfMonth) + " to " + DateFormat("yyyy-MM-dd").format(lastDayOfMonth);
    }
    //pass 7 day
    if (selectedFilterTypeIndex == 2){
      DateTime sPass7Day = DateTime.now().subtract(const Duration(days: 7));
      DateTime lPass7Day = DateTime.now().subtract(const Duration(days: 1));
      title += "From " + DateFormat("yyyy-MM-dd").format(sPass7Day) + " to " + DateFormat("yyyy-MM-dd").format(lPass7Day);     
    }
    //range
    if (selectedFilterTypeIndex == 3){  
      title += "From " + DateFormat("yyyy-MM-dd").format(_sFocusedDay) + " to " + DateFormat("yyyy-MM-dd").format(_lFocusedDay);
    }
    return title;
  }

  String getReportResult(){

    String result = "";
    int dayCount = 0;
    double resultAmount = 0;

    var tempList;
    result += "\nThe average of ";

    //budget
    if (selectedItemTypeIndex == 0){
      result += "Budget";
      tempList = widget.passedBudgetList;
    }
    //saving
    if (selectedItemTypeIndex == 1){
      result += "Saving";
      tempList = widget.passedSavingList;
    } 
    //event
    if (selectedItemTypeIndex == 2){
      result += "Event";
      tempList = widget.passedEventList;
    }

    //weekly
    if (selectedFilterTypeIndex == 0 ){
      resultAmount = getWeeklyResults(tempList);
      dayCount = 7;
    }
    //monthly
    if (selectedFilterTypeIndex == 1){
      resultAmount = getMonthlyResults(tempList);
      dayCount =  DateTime(DateTime.now().year, DateTime.now().month +1, 0).day;
    }
    //pass 7 day
    if (selectedFilterTypeIndex == 2){
      resultAmount = getPass7Day(tempList);
      dayCount = 7;
    }
    //range
    if (selectedFilterTypeIndex == 3){
      resultAmount = getRange(tempList);
      dayCount = _lFocusedDay.difference(_sFocusedDay).inDays;
    }
  
    result += " in " + dayCount.toString() + " day(s) are\n";
    result += resultAmount.toStringAsFixed(2) + " per day";

    return result;

  }

  double getWeeklyResults(var list){
    double amount = 0;
    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday));
    DateTime lastDayOfWeek = today.add(Duration(days: DateTime.daysPerWeek - today.weekday + 1));
    int totalDayInWeek = 7;

    list.forEach((element) {
      DateTime itemDates = DateFormat("yyyy-MM-dd").parse(element.dateTime);
      if (itemDates.isAfter(firstDayOfWeek) && itemDates.isBefore(lastDayOfWeek)){
        (selectedItemTypeIndex == 2) 
        ? amount ++ 
        : (selectedItemTypeIndex == 0 || selectedItemTypeIndex == 1) 
        ? amount += element.amount 
        : 0;
      }
    });
    return amount/totalDayInWeek;
  }

  double getMonthlyResults(var list){
    double amount = 0;
    DateTime today = DateTime.now();
    DateTime firstDayOfMonth = DateTime.utc(DateTime.now().year, DateTime.now().month).subtract(const Duration(days: 1));
    DateTime lastDayOfMonth = DateTime.utc(DateTime.now().year, DateTime.now().month+1);
    int totalDayInMonth = DateTime(today.year, today.month +1, 0).day;
    list.forEach((element){
      DateTime itemDates = DateFormat("yyyy-MM-dd").parse(element.dateTime);
      if (itemDates.isAfter(firstDayOfMonth) && itemDates.isBefore(lastDayOfMonth)){
        (selectedItemTypeIndex == 2)
        ? amount ++ 
        : (selectedItemTypeIndex == 0 || selectedItemTypeIndex == 1)
        ? amount += element.amount
        : 0;
      }
    });
    return amount / totalDayInMonth;
  }

  double getPass7Day(var list){
    double amount = 0;
    DateTime today = DateTime.now();
    DateTime sPass7Day = DateTime.now().subtract(const Duration(days: 8));
    DateTime lPass7Day = DateTime.now();
    int sevenDay = 7;   
    list.forEach((element){
      DateTime itemDates = DateFormat("yyyy-MM-dd").parse(element.dateTime);
      if(itemDates.isAfter(sPass7Day) && itemDates.isBefore(lPass7Day)){
        (selectedItemTypeIndex == 2)
        ? amount ++ 
        : (selectedItemTypeIndex == 0 || selectedItemTypeIndex == 1)
        ? amount += element.amount
        : 0;
      }
    });
    return amount/sevenDay;
  }

  double getRange(var list){
    double amount = 0;
    DateTime startDate = _sFocusedDay.subtract(const Duration(days: 1));
    DateTime lastDate = _lFocusedDay.add(const Duration(days: 1));
    int day = _lFocusedDay.difference(_sFocusedDay).inDays;
    list.forEach((element){
      DateTime itemDates = DateFormat("yyyy-MM-dd").parse(element.dateTime);
      if(itemDates.isAfter(startDate) && itemDates.isBefore(lastDate)){
        (selectedItemTypeIndex == 2)
        ? amount ++
        : (selectedItemTypeIndex == 0 || selectedItemTypeIndex == 1)
        ? amount += element.amount
        : 0; 
      }
    });
    return amount/day;
  }
  void pass() {}

  void debug(){

  }


}
