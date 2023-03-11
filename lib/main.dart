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
      home: Container(),
    );
  }
}
