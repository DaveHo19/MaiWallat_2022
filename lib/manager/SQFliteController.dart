import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_tagItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_app/component/_enumList.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path/path.dart';

class MySQFliteController {
  final String budgetTable = "expenseBudget";
  final String eventTable = "expenseEvent";
  final String savingTable = "expenseSaving";
  final String budgetTagTable = "expenseBudgetTag";
  final String savingTagTable = "expenseSavingTag";

  Future<Database> getDatabaseRef() async {
    WidgetsFlutterBinding.ensureInitialized();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'expenses.db');
    return await openDatabase(path, version: 1, onCreate: createDatabase);
  }

  void createDatabase(Database db, int version) async {

    Batch batch = db.batch();
    batch.execute('''CREATE TABLE IF NOT EXISTS $budgetTable(
                     id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     tag TEXT,
                     description TEXT,
                     amount REAL,
                     dateTime TEXT)
                  ''');
    batch.execute('''CREATE TABLE IF NOT EXISTS $eventTable(
                     id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     title TEXT,
                     description TEXT,
                     dateTime TEXT,
                     duration TEXT)
                  ''');

    batch.execute('''CREATE TABLE IF NOT EXISTS $savingTable(
                     id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     tag TEXT,
                     amount REAL,
                     dateTime TEXT)
                  ''');
    batch.execute('''CREATE TABLE IF NOT EXISTS $budgetTagTable(
                     id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     name TEXT)
                  ''');
    batch.execute('''CREATE TABLE IF NOT EXISTS $savingTagTable(
                     id INTEGER PRIMARY KEY AUTOINCREMENT, 
                     name TEXT)
                  ''');

    List<dynamic> res = await batch.commit();

  }

  Future<int> insertBudget(Budget budget) async {
    final db = await getDatabaseRef();
    return await db.insert(budgetTable, budget.toMap());
  }

  Future<int> insertSaving(Saving saving) async {
    final db = await getDatabaseRef();
    return await db.insert(savingTable, saving.toMap());
  }

  Future<int> insertEvent(Event event) async {
    final db = await getDatabaseRef();
    return await db.insert(eventTable, event.toMap());
  }

  Future<int> insertBudgetTag(TagItem tagName) async {
    final db = await getDatabaseRef();
    return await db.insert(budgetTagTable, tagName.toMap());
  }

  Future<int> insertSavingTag(TagItem tagName) async {
    final db = await getDatabaseRef();
    return await db.insert(savingTagTable, tagName.toMap());
  }

  Future<List<Budget>> retrieveBudgetList() async {
    final db = await getDatabaseRef();
    final List<Map<String, dynamic>> maps = await db.query(budgetTable);

    return List.generate(
        maps.length,
        (i) => Budget(
              id: maps[i]['id'],
              tag: maps[i]['tag'],
              description: maps[i]['description'],
              amount: maps[i]['amount'],
              dateTime: maps[i]['dateTime'],
            ));
  }

  Future<List<Saving>> retrieveSavingList() async {
    final db = await getDatabaseRef();
    final List<Map<String, dynamic>> maps = await db.query(savingTable);

    return List.generate(
        maps.length,
        (i) => Saving(
              id: maps[i]['id'],
              tag: maps[i]['tag'],
              amount: maps[i]['amount'],
              dateTime: maps[i]['dateTime'],
            ));
  }

  Future<List<Event>> retrieveEventList() async {
    final db = await getDatabaseRef();
    final List<Map<String, dynamic>> maps = await db.query(eventTable);

    return List.generate(
        maps.length,
        (i) => Event(
              id: maps[i]['id'],
              title: maps[i]['title'],
              description: maps[i]['description'],
              dateTime: maps[i]['dateTime'],
              duration: maps[i]['duration'],
            ));
  }

  Future<List<TagItem>> retrieveBudgetTagList() async {
    final db = await getDatabaseRef();
    final List<Map<String, dynamic>> maps = await db.query(budgetTagTable);

    return List.generate(
        maps.length,
        (i) => TagItem(
              id: maps[i]['id'],
              name: maps[i]['name'],
            ));
  }

  Future<List<TagItem>> retrieveSavingTagList() async {
    final db = await getDatabaseRef();
    final List<Map<String, dynamic>> maps = await db.query(savingTagTable);

    return List.generate(
        maps.length,
        (i) => TagItem(
              id: maps[i]['id'],
              name: maps[i]['name'],
            ));
  }

  Future<int> updateSelectedBudget(Budget budget) async {
    final db = await getDatabaseRef();
    return await db.update(budgetTable, budget.toMap(),
        where: 'id = ?', whereArgs: [budget.id]);
  }

  Future<int> updateSelectedSaving(Saving saving) async {
    final db = await getDatabaseRef();
    return await db.update(savingTable, saving.toMap(),
        where: 'id = ?', whereArgs: [saving.id]);
  }

  Future<int> updateSelectedEvent(Event event) async {
    final db = await getDatabaseRef();
    return await db.update(eventTable, event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> updateSelectedBudgetTag(TagItem budgetTag) async {
    final db = await getDatabaseRef();
    return await db.update(budgetTagTable, budgetTag.toMap(),
        where: 'id = ?', whereArgs: [budgetTag.id]);
  }

  Future<int> updateSelectedSavingTag(TagItem savingTag) async {
    final db = await getDatabaseRef();
    return await db.update(savingTagTable, savingTag.toMap(),
        where: 'id = ?', whereArgs: [savingTag.id]);
  }

  Future<int> deleteSelectedBudget(Budget budget) async {
    final db = await getDatabaseRef();
    return await db
        .delete(budgetTable, where: 'id = ?', whereArgs: [budget.id]);
  }

  Future<int> deleteSelectedSaving(Saving saving) async {
    final db = await getDatabaseRef();
    return await db
        .delete(savingTable, where: 'id = ?', whereArgs: [saving.id]);
  }

  Future<int> deleteSelectedEvent(Event event) async {
    final db = await getDatabaseRef();
    return await db.delete(eventTable, where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteSelectedBudgetTag(TagItem budgetTag) async {
    final db = await getDatabaseRef();
    return await db
        .delete(budgetTagTable, where: 'id = ?', whereArgs: [budgetTag.id]);
  }

  Future<int> deleteSelectedSavingTag(TagItem savingTag) async {
    final db = await getDatabaseRef();
    return await db
        .delete(savingTagTable, where: 'id = ?', whereArgs: [savingTag.id]);
  }
}
