import 'dart:io';
import 'package:expense_app/ItemScene/ManageItemScreen.dart';
import 'package:expense_app/ItemScene/ViewItemListScreen.dart';
import 'package:expense_app/component/_enumList.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'NavScene/ExpensesScreen.dart';
import 'NavScene/DashboardScreen.dart';
import 'NavScene/StatisticScreen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: BaseScreen(),
    );
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 1;
  final GlobalKey<State> _myKey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgetOptions.add(MyExpensesScreen(
      key: _myKey,
    ));
    _widgetOptions.add(MyDashboardScreen(
      key: _myKey,
    ));
    _widgetOptions.add(MyStatisticScreen(
      key: _myKey,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        title: const Text(':)'),
      ),
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.more_horiz),
        onPressed: onFabTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'My Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistic',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orangeAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  void onFabTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Navigation'),
        content: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 1.2,
          padding: const EdgeInsets.all(4.0),
          child: _buildGridControls(context),
        ),
      ),
    );
  }

  Widget _buildGridControls(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: [
        GFIconButton(
          icon: const Icon(Icons.paid_outlined,
              color: Colors.white, size: GFSize.LARGE),
          color: Colors.orangeAccent,
          onPressed: goToManageBudgetScreen,
        ),
        GFIconButton(
          icon: const Icon(Icons.savings_outlined,
              color: Colors.white, size: GFSize.LARGE),
          color: Colors.orangeAccent,
          size: GFSize.MEDIUM,
          onPressed: goToManageSavingScreen,
        ),
        GFIconButton(
          icon: const Icon(Icons.event_note_outlined,
              color: Colors.white, size: GFSize.LARGE),
          color: Colors.orangeAccent,
          size: GFSize.MEDIUM,
          onPressed: goToManageEventScreen,
        ),
        GFIconButton(
          icon: const Icon(Icons.sell, color: Colors.white, size: GFSize.LARGE),
          color: Colors.pink,
          size: GFSize.MEDIUM,
          onPressed: goToManageBudgetTagScreen,
        ),
        GFIconButton(
          icon: const Icon(Icons.sell, color: Colors.white, size: GFSize.LARGE),
          color: Colors.yellow,
          size: GFSize.MEDIUM,
          onPressed: goToManageSavingTagScreen,
        ),
         GFIconButton(
          icon: const Icon(Icons.question_mark, color: Colors.white, size: GFSize.LARGE),
          color: Colors.green,
          size: GFSize.MEDIUM,
          onPressed: message,
        ),
         GFIconButton(
          icon: const Icon(Icons.list_alt, color: Colors.white, size: GFSize.LARGE),
          color: Colors.pink,
          size: GFSize.MEDIUM,
          onPressed: goToViewBudgetTagListScreen,
        ),
        GFIconButton(
          icon: const Icon(Icons.list_alt, color: Colors.white, size: GFSize.LARGE),
          color: Colors.yellow,
          size: GFSize.MEDIUM,
          onPressed: goToViewSavingTagListScreen,
        ),       
        GFIconButton(
          icon: const Icon(Icons.question_mark, color: Colors.white, size: GFSize.LARGE),
          color: Colors.green,
          size: GFSize.MEDIUM,
          onPressed: message,
        ),  
      ],
    );
  }

  void pass() {}

  void message(){
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
          title: const Text("Message"),
          content: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(4.0),
            child: const Center(child: Text("Eh-Heh")),
          ),
      )); 
  }
  void refreshState() async {
    _myKey.currentState!.setState(() {});
  }

  void goToManageBudgetScreen() async {
    bool result = false;
    Navigator.pop(context);
    result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyItemManageScreen(
                manageType: ManageEnum.create, itemType: ItemEnum.budget)));
    if (result) {
      refreshState();
    }
  }

  void goToManageSavingScreen() async {
    bool result = false;
    Navigator.pop(context);
    result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyItemManageScreen(
                manageType: ManageEnum.create, itemType: ItemEnum.saving)));
    if (result) {
      refreshState();
    }
  }

  void goToManageEventScreen() async {
    bool result = false;
    Navigator.pop(context);
    result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyItemManageScreen(
                manageType: ManageEnum.create, itemType: ItemEnum.event)));
    if (result) {
      refreshState();
    }
  }

  void goToManageBudgetTagScreen() async {
    bool result = false;
    Navigator.pop(context);
    result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyItemManageScreen(
                manageType: ManageEnum.create, itemType: ItemEnum.budgetTag)));

    if (result) {
      refreshState();
    }
  }

  void goToManageSavingTagScreen() async {
    bool result = false;
    Navigator.pop(context);
    result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyItemManageScreen(
                manageType: ManageEnum.create, itemType: ItemEnum.savingTag)));

    if (result) {
      refreshState();
    }
  }

  void goToViewBudgetTagListScreen() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyViewItemListScreen(itemType: ItemEnum.budgetTag)));
  }

  void goToViewSavingTagListScreen(){
      Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyViewItemListScreen(itemType: ItemEnum.savingTag)));  
  }
}
