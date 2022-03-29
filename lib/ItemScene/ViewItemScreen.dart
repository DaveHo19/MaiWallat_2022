import 'package:expense_app/ItemScene/ManageItemScreen.dart';
import 'package:expense_app/component/_enumList.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/component/_tagItem.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/component/_budget.dart';

class MyViewItemDetailScene extends StatelessWidget {
  MyViewItemDetailScene({
    Key? key,
    required this.itemType,
    this.passedBudget,
    this.passedSaving,
    this.passedEvent,
    this.passedTag,
  }) : super(key: key);

  final ItemEnum itemType;
  Budget? passedBudget;
  Saving? passedSaving;
  Event? passedEvent;
  TagItem? passedTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        title: Text(generateTitleHeading()),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Icon(
                      Icons.edit,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Icon(
                      Icons.delete,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ];
              },
              onSelected: (int i) => {
                    menuItemHandler(context, i),
                  }),
        ],
      ),
      body: SafeArea(child: _buildContent(context)),
      resizeToAvoidBottomInset: false,
    );
  }

  void menuItemHandler(BuildContext context, int i) {
    switch (i) {
      case 0:
        goToManageItemScreen(context, itemType, ManageEnum.edit);
        break;
      case 1:
        goToManageItemScreen(context, itemType, ManageEnum.delete);
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: _buildHeading(context),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: ((itemType == ItemEnum.event) ||
                  (itemType == ItemEnum.budgetTag) ||
                  (itemType == ItemEnum.savingTag))
              ? _buildTitle(context)
              : ((itemType == ItemEnum.budget) || (itemType == ItemEnum.saving))
                  ? _buildTag(context)
                  : Container(), //tag name
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: ((itemType == ItemEnum.event) ||
                    (itemType == ItemEnum.budget) ||
                    (itemType == ItemEnum.saving))
                ? _buildDateTime(context)
                : Container()),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: (itemType == ItemEnum.event)
              ? _buildDuration(context)
              : ((itemType == ItemEnum.budget || (itemType == ItemEnum.saving)))
                  ? _buildAmount(context)
                  : Container(),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: (itemType == ItemEnum.event)
              ? _buildDescription(context)
              : (itemType == ItemEnum.budget)
                  ? _buildDescription(context)
                  : Container(),
        ),
      ],
    );
  }

  Widget _buildHeading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(4.0),
      child: Text(
        generateTitleHeading(), //text
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Tag',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        initialValue: (itemType == ItemEnum.budget)
            ? (passedBudget?.tag ?? "Other")
            : (itemType == ItemEnum.saving)
                ? (passedSaving?.tag ?? "Other")
                : "Other",
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        initialValue: (itemType == ItemEnum.event)
            ? (passedEvent?.title ?? "None")
            : ((itemType == ItemEnum.budgetTag) ||
                    (itemType == ItemEnum.savingTag))
                ? (passedTag?.name ?? "None")
                : "None",
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  Widget _buildDateTime(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        initialValue: (itemType == ItemEnum.budget)
            ? (passedBudget?.dateTime ?? "-")
            : (itemType == ItemEnum.saving)
                ? (passedSaving?.dateTime ?? "-")
                : (itemType == ItemEnum.event)
                    ? (passedEvent?.dateTime ?? "-")
                    : DateFormat("yyyy-MM-dd").format(DateTime.now()),
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  Widget _buildDuration(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Duration',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        initialValue: (itemType == ItemEnum.event)
            ? (passedEvent?.duration ?? "None")
            : "None",
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Description',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        maxLines: 5,
        initialValue: (itemType == ItemEnum.budget)
            ? (passedBudget?.description ?? "")
            : (itemType == ItemEnum.event)
                ? (passedEvent?.description ?? "")
                : "",
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: (MediaQuery.of(context).size.width / 1.5),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Amount',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        initialValue: (itemType == ItemEnum.budget)
            ? (passedBudget?.amount.toStringAsFixed(2) ?? "0")
            : (itemType == ItemEnum.saving)
                ? (passedSaving?.amount.toStringAsFixed(2) ?? "0")
                : "0",
        readOnly: true,
        //enabled: false,
      ),
    );
  }

  void pass() {
  }


  void goToManageItemScreen(
      BuildContext context, ItemEnum itemType, ManageEnum action) async {
    Navigator.pop(context);
    switch (itemType) {
      case ItemEnum.budget:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyItemManageScreen(
                      manageType: action,
                      itemType: itemType,
                      passBudgetItem: passedBudget,
                    )));
        break;
      case ItemEnum.saving:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyItemManageScreen(
                      manageType: action,
                      itemType: itemType,
                      passSavingItem: passedSaving,
                    )));
        break;
      case ItemEnum.event:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyItemManageScreen(
                      manageType: action,
                      itemType: itemType,
                      passEventItem: passedEvent,
                    )));
        break;
      case ItemEnum.budgetTag:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyItemManageScreen(
                      manageType: action,
                      itemType: itemType,
                      passTagItem: passedTag,
                    )));
        break;
      case ItemEnum.savingTag:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyItemManageScreen(
                      manageType: action,
                      itemType: itemType,
                      passTagItem: passedTag,
                    )));
        break;
    }
  }

  String generateTitleHeading() {
    String title = "";
    switch (itemType) {
      case ItemEnum.budget:
        title += "View Budget";
        break;
      case ItemEnum.saving:
        title += "View Saving";
        break;
      case ItemEnum.event:
        title += "View Event";
        break;
      case ItemEnum.budgetTag:
        break;
      case ItemEnum.savingTag:
        break;
    }

    return title;
  }
}
