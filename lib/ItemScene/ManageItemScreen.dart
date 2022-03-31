import 'package:expense_app/component/_enumList.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_initTagList.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/component/_tagItem.dart';
import 'package:expense_app/component/_budget.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyItemManageScreen extends StatefulWidget {
  const MyItemManageScreen(
      {Key? key,
      required this.manageType,
      required this.itemType,
      this.passBudgetItem,
      this.passSavingItem,
      this.passEventItem,
      this.passTagItem})
      : super(key: key);

  final ManageEnum manageType;
  final ItemEnum itemType;
  final Budget? passBudgetItem;
  final Saving? passSavingItem;
  final Event? passEventItem;
  final TagItem? passTagItem;

  @override
  State<MyItemManageScreen> createState() => _MyItemManageScreenState();
}

class _MyItemManageScreenState extends State<MyItemManageScreen> {
  final textTitleController = TextEditingController();
  final textAmountController = TextEditingController();
  final textDescController = TextEditingController();
  final textDateController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var tagList = <String>[];
  var durationList = <String>[];
  String? selectedTagItem;
  String? selectedDurationItem;
  double amount = 0;

  @override
  void initState() {
    super.initState();
    generateTag();
    generateDuration();
    initialSelectedItem();
    if ((widget.itemType == ItemEnum.budget) ||
        (widget.itemType == ItemEnum.saving)) {
      textAmountController.text = (widget.manageType == ManageEnum.create)
          ? 0.toString()
          : (widget.itemType == ItemEnum.budget)
              ? widget.passBudgetItem!.amount.toString()
              : widget.passSavingItem!.amount.toString();
    }
    if ((widget.itemType == ItemEnum.budget) ||
        (widget.itemType == ItemEnum.event)) {
      textDescController.text = (widget.manageType == ManageEnum.create)
          ? ""
          : (widget.itemType == ItemEnum.budget)
              ? widget.passBudgetItem?.description ?? ""
              : widget.passEventItem?.description ?? "";
    }
    if ((widget.itemType == ItemEnum.event) ||
        (widget.itemType == ItemEnum.budgetTag) ||
        (widget.itemType == ItemEnum.savingTag)) {
      textTitleController.text = (widget.manageType == ManageEnum.create)
          ? ""
          : (widget.itemType == ItemEnum.event)
              ? widget.passEventItem!.title
              : ((widget.itemType == ItemEnum.budgetTag) ||
                      (widget.itemType == ItemEnum.savingTag))
                  ? widget.passTagItem!.name
                  : "";
    }
    if (widget.itemType == ItemEnum.event) {
      textDateController.text = (widget.manageType == ManageEnum.create)
          ? DateFormat("yyyy-MM-dd").format(DateTime.now())
          : widget.passEventItem?.dateTime ??
              DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  @override
  void dispose() {
    textTitleController.dispose();
    textAmountController.dispose();
    textDescController.dispose();
    textDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
          title: Text(getTitle()),
        ),
        body: SafeArea(
          child: _buildContent(context),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
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
        //),
        //first row
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: ((widget.itemType == ItemEnum.event) ||
                    (widget.itemType == ItemEnum.budgetTag) ||
                    (widget.itemType == ItemEnum.savingTag))
                ? _buildTitleInputField(context)
                : ((widget.itemType == ItemEnum.budget) ||
                        (widget.itemType == ItemEnum.saving))
                    ? _buildTagSelection(context)
                    : Container(), // tag name?
          ),
        ),
        //second row
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: (widget.itemType == ItemEnum.event)
                ? _buildDateSelectionField(context)
                : ((widget.itemType == ItemEnum.budget) ||
                        (widget.itemType == ItemEnum.saving))
                    ? _buildAmountInputField(context)
                    : ((widget.itemType == ItemEnum.budgetTag) ||
                            (widget.itemType == ItemEnum.savingTag))
                        ? _buildButton(context)
                        : Container(), // tag button
          ),
        ),
        //third row
        Expanded(
          flex: (widget.itemType == ItemEnum.budget) ? 2 : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: (widget.itemType == ItemEnum.event)
                ? _buildDurationField(context)
                : (widget.itemType == ItemEnum.budget)
                    ? _buildDescriptionInputField(context)
                    : (widget.itemType == ItemEnum.saving)
                        ? _buildButton(context)
                        : // saving button
                        Container(), //tag
          ),
        ),
        //fourth row
        Expanded(
          flex: (widget.itemType == ItemEnum.event) ? 2 : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: (widget.itemType == ItemEnum.event)
                ? _buildDescriptionInputField(context)
                : (widget.itemType == ItemEnum.budget)
                    ? _buildButton(context)
                    : // budget button
                    Container(), //saving and tag
          ),
        ),
        //fifth row
        Expanded(
          flex: (widget.itemType == ItemEnum.event) ? 1 : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: (widget.itemType == ItemEnum.event)
                ? _buildButton(context)
                : // event button
                Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(4.0),
      child: Text(
        getTitle(),
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTagSelection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Tag",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.start),
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        value: selectedTagItem,
        elevation: 8,
        alignment: Alignment.center,
        onChanged: (widget.manageType == ManageEnum.delete)
            ? null
            : (String? newvalue) {
                setState(() {
                  selectedTagItem = newvalue;
                });
              },
        items: tagList.map<DropdownMenuItem<String>>((String va) {
          return DropdownMenuItem<String>(
            value: va,
            child: Text(va),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTitleInputField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Title",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: "Enter title",
        ),
        keyboardType: TextInputType.text,
        controller: textTitleController,
        readOnly: (widget.manageType == ManageEnum.delete),
      ),
    );
  }

  Widget _buildDateSelectionField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: GFIconButton(
            icon: const Icon(Icons.edit_calendar_outlined,
                color: Colors.white, size: GFSize.SMALL),
            color: Colors.deepOrangeAccent,
            shape: GFIconButtonShape.standard,
            size: GFSize.LARGE,
            onPressed: callCalendar,
          ),
          border: const OutlineInputBorder(),
          labelText: "Date",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        keyboardType: TextInputType.text,
        controller: textDateController,
        readOnly: true,
      ),
    );
  }

  Widget _buildDurationField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Duration",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        value: selectedDurationItem,
        elevation: 8,
        alignment: Alignment.center,
        onChanged: (widget.manageType == ManageEnum.delete)
            ? null
            : (String? newvalue) {
                setState(() {
                  selectedDurationItem = newvalue;
                });
              },
        items: durationList.map<DropdownMenuItem<String>>((String va) {
          return DropdownMenuItem<String>(
            value: va,
            child: Text(va),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountInputField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Amount",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: "Enter amount",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
        controller: textAmountController,
        //initialValue: (widget.type == ManageEnum.create) ? 0.toStringAsFixed(2) : widget.passItem!.amount.toStringAsFixed(2),
        readOnly: (widget.manageType == ManageEnum.delete),
      ),
    );
  }

  Widget _buildDescriptionInputField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Description",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: 'Enter description',
        ),
        keyboardType: TextInputType.text,
        maxLines: 5,
        controller: textDescController,
        //initialValue: (widget.type == ManageEnum.create) ? "" : widget.passItem!.description,
        readOnly: (widget.manageType == ManageEnum.delete),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Center(
      child: GFButton(
        text: (widget.manageType == ManageEnum.create)
            ? "Create"
            : (widget.manageType == ManageEnum.edit)
                ? "Edit"
                : (widget.manageType == ManageEnum.delete)
                    ? "Delete"
                    : "",
        size: GFSize.LARGE,
        icon: Icon(
          (widget.manageType == ManageEnum.create)
              ? Icons.save_outlined
              : (widget.manageType == ManageEnum.edit)
                  ? Icons.edit_outlined
                  : (widget.manageType == ManageEnum.delete)
                      ? Icons.delete_outline
                      : Icons.question_mark_outlined,
          color: Colors.white,
          size: GFSize.MEDIUM,
        ),
        color: Colors.orangeAccent,
        onPressed: (widget.manageType == ManageEnum.create)
            ? saveAction
            : (widget.manageType == ManageEnum.edit)
                ? updateAction
                : (widget.manageType == ManageEnum.delete)
                    ? deleteAction
                    : pass, //none
      ),
    );
  }

  void initialSelectedItem() {
    if ((widget.itemType == ItemEnum.budgetTag) ||
        (widget.itemType == ItemEnum.savingTag)) {
      return;
    }
    if ((widget.itemType != ItemEnum.event)) {
      String selectedTag;
      if (widget.manageType != ManageEnum.create) {
        selectedTag = ((widget.itemType == ItemEnum.budget)
                ? widget.passBudgetItem?.tag
                : widget.passSavingItem?.tag) ??
            "";
        selectedTagItem = tagList.firstWhere(
            (element) => element == selectedTag,
            orElse: () => "Other");
      } else {
        selectedTagItem = tagList.first;
      }
    } else {
      if (widget.manageType != ManageEnum.create) {
        selectedDurationItem = durationList.firstWhere(
            (element) => element == widget.passEventItem?.duration,
            orElse: () => "None");
      } else {
        selectedDurationItem = durationList.first;
      }
    }
  }

  Future<void> generateTag() async {
    InitTagList initTagList = InitTagList();
    tagList.clear();
    tagList = (widget.itemType == ItemEnum.budget)
        ? initTagList.getBudgetTagList()
        : (widget.itemType == ItemEnum.saving)
            ? initTagList.getSavingTagList()
            : <String>[];

    if (!kIsWeb) {
      MySQFliteController mySQF = MySQFliteController();
      List<TagItem> tagItemFromDB = <TagItem>[];
      if (widget.itemType == ItemEnum.budget) {
        tagItemFromDB = await mySQF.retrieveBudgetTagList();
        if (tagItemFromDB.isNotEmpty) {
          tagItemFromDB.forEach((element) {
            tagList.add(element.name);
          });
        }
      }
      if (widget.itemType == ItemEnum.saving) {
        tagItemFromDB = await mySQF.retrieveSavingTagList();
        if (tagItemFromDB.isNotEmpty) {
          tagItemFromDB.forEach((element) {
            tagList.add(element.name);
          });
        }
      }
    }
  }

  void generateDuration() {
    durationList.add("None");
    for (int i = 0; i < 6; i++) {
      durationList.add((i + 1).toString() + " hour(s)");
    }
    durationList.add("Half day");
    durationList.add("Full day");
  }

  void pass() {}

  void saveAction() async {
    if (validate()) {
      switch (widget.itemType) {
        case ItemEnum.budget:
          //debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Budget newBudget = Budget(
              tag: selectedTagItem ?? "Other",
              amount: double.parse(textAmountController.text),
              description: textDescController.text,
              dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            );
            int saveResult = await mySQF.insertBudget(newBudget);
            SnackBar sbMsg = (saveResult == 0)
                ? const SnackBar(
                    content: Text("Error => Failed to save budget!"))
                : const SnackBar(
                    content: Text("Success => Successfully saved!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (saveResult != 0) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
        case ItemEnum.saving: //debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Saving newSaving = Saving(
              tag: selectedTagItem ?? "Other",
              amount: double.parse(textAmountController.text),
              dateTime: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            );
            int saveResult = await mySQF.insertSaving(newSaving);
            SnackBar sbMsg = (saveResult == 0)
                ? const SnackBar(
                    content: Text("Error => Failed to save saving!"))
                : const SnackBar(
                    content: Text("Success => Successfully saved!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (saveResult != 0) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
        case ItemEnum.event:
          //debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Event newEvent = Event(
              title: textTitleController.text,
              description: textDescController.text,
              dateTime: textDateController.text,
              duration: selectedDurationItem ?? "None",
            );
            int saveResult = await mySQF.insertEvent(newEvent);
            SnackBar sbMsg = (saveResult == 0)
                ? const SnackBar(
                    content: Text("Error => Failed to save event!"))
                : const SnackBar(
                    content: Text("Success => Successfully saved!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (saveResult != 0) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
        case ItemEnum.budgetTag:
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            TagItem newTagItem = TagItem(name: textTitleController.text);
            int saveResult = await mySQF.insertBudgetTag(newTagItem);
            SnackBar sbMsg = (saveResult == 0)
                ? const SnackBar(
                    content: Text("Error => Failed to save budget tag!"))
                : const SnackBar(
                    content: Text("Sucess => Successfully saved!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (saveResult != 0) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
        case ItemEnum.savingTag:
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            TagItem newTagItem = TagItem(name: textTitleController.text);
            int saveResult = await mySQF.insertSavingTag(newTagItem);
            SnackBar sbMsg = (saveResult == 0)
                ? const SnackBar(
                    content: Text("Error => Failed to save saving tag!"))
                : const SnackBar(
                    content: Text("Sucess => Successfully saved!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (saveResult != 0) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
      }
    } else {
      return;
    }
  }

  void updateAction() async {
    if (validate()) {
      switch (widget.itemType) {
        case ItemEnum.budget:
          //for debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Budget updatedBudget = Budget(
              id: widget.passBudgetItem!.id,
              tag: selectedTagItem ?? "Other",
              amount: double.parse(textAmountController.text),
              description: textDescController.text,
              dateTime: widget.passBudgetItem!.dateTime,
            );
            int updateResult = await mySQF.updateSelectedBudget(updatedBudget);
            SnackBar sbMsg = (updateResult == 1)
                ? const SnackBar(
                    content: Text("Success => Successfully edited!"))
                : const SnackBar(
                    content: Text("Error => Failed to edit budget!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (updateResult == 1) {
              Navigator.pop(context, true);
              //return view budget page
            } else {
              return;
            }
          }
          break;
        case ItemEnum.saving:
          //for debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Saving updatedSaving = Saving(
              id: widget.passSavingItem!.id,
              tag: selectedTagItem ?? "Other",
              amount: double.parse(textAmountController.text),
              dateTime: widget.passSavingItem!.dateTime,
            );
            int updateResult = await mySQF.updateSelectedSaving(updatedSaving);
            SnackBar sbMsg = (updateResult == 1)
                ? const SnackBar(
                    content: Text("Success => Successfully edited!"))
                : const SnackBar(
                    content: Text("Error => Failed to edit saving!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (updateResult == 1) {
              Navigator.pop(context, true);
              //return view budget page
            } else {
              return;
            }
          }
          break;
        case ItemEnum.event:
          //for debug purpose
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            Event updatedEvent = Event(
              id: widget.passEventItem!.id,
              title: textTitleController.text,
              description: textDescController.text,
              dateTime: textDateController.text,
              duration: selectedDurationItem ?? "None",
            );
            int updateResult = await mySQF.updateSelectedEvent(updatedEvent);
            SnackBar sbMsg = (updateResult == 1)
                ? const SnackBar(
                    content: Text("Success => Successfully edited!"))
                : const SnackBar(
                    content: Text("Error => Failed to edit event!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (updateResult == 1) {
              Navigator.pop(context, true);
              //return view budget page
            } else {
              return;
            }
          }
          break;
        case ItemEnum.budgetTag:
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            TagItem updatedTagItem = TagItem(
                id: widget.passTagItem!.id, name: textTitleController.text);
            int updateResult =
                await mySQF.updateSelectedBudgetTag(updatedTagItem);
            SnackBar sbMsg = (updateResult == 1)
                ? const SnackBar(
                    content: Text("Success => Successfully edited!"))
                : const SnackBar(
                    content: Text("Error => Failed to edit budget tag!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (updateResult == 1) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
        case ItemEnum.savingTag:
          if (kIsWeb) {
            Navigator.pop(context, true);
          } else {
            MySQFliteController mySQF = MySQFliteController();
            TagItem updatedTagItem = TagItem(
                id: widget.passTagItem!.id, name: textTitleController.text);
            int updateResult =
                await mySQF.updateSelectedSavingTag(updatedTagItem);
            SnackBar sbMsg = (updateResult == 1)
                ? const SnackBar(
                    content: Text("Success => Successfully edited!"))
                : const SnackBar(
                    content: Text("Error => Failed to edit saving tag!"));
            ScaffoldMessenger.of(context).showSnackBar(sbMsg);
            if (updateResult == 1) {
              Navigator.pop(context, true);
            } else {
              return;
            }
          }
          break;
      }
    } else {
      return;
    }
  }

  void deleteAction() async {
    switch (widget.itemType) {
      case ItemEnum.budget:
        //for debug purpose
        if (kIsWeb) {
          Navigator.pop(context, true);
        } else {
          MySQFliteController mySQF = MySQFliteController();
          Budget deleteBudget = widget.passBudgetItem!;
          int deleteResult = await mySQF.deleteSelectedBudget(deleteBudget);
          SnackBar sbMsg = (deleteResult != 0)
              ? const SnackBar(
                  content: Text("Success => Successfully deleted!"))
              : const SnackBar(
                  content: Text("Error => Failed to delete budget!"));
          ScaffoldMessenger.of(context).showSnackBar(sbMsg);
          if (deleteResult != 0) {
            Navigator.pop(context, true);
          }
        }
        break;
      case ItemEnum.saving:
        //for debug purpose
        if (kIsWeb) {
          Navigator.pop(context, true);
        } else {
          MySQFliteController mySQF = MySQFliteController();
          Saving deleteSaving = widget.passSavingItem!;
          int deleteResult = await mySQF.deleteSelectedSaving(deleteSaving);
          SnackBar sbMsg = (deleteResult != 0)
              ? const SnackBar(
                  content: Text("Success => Successfully deleted!"))
              : const SnackBar(
                  content: Text("Error => Failed to delete saving!"));
          ScaffoldMessenger.of(context).showSnackBar(sbMsg);
          if (deleteResult != 0) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
        break;
      case ItemEnum.event:
        //for debug purpose
        if (kIsWeb) {
          Navigator.pop(context, true);
        } else {
          MySQFliteController mySQF = MySQFliteController();
          Event deleteEvent = widget.passEventItem!;
          int deleteResult = await mySQF.deleteSelectedEvent(deleteEvent);
          SnackBar sbMsg = (deleteResult != 0)
              ? const SnackBar(
                  content: Text("Success => Successfully deleted!"))
              : const SnackBar(
                  content: Text("Error => Failed to delete event!"));
          ScaffoldMessenger.of(context).showSnackBar(sbMsg);
          if (deleteResult != 0) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
        break;
      case ItemEnum.budgetTag:
        if (kIsWeb) {
          Navigator.pop(context, true);
        } else {
          MySQFliteController mySQF = MySQFliteController();
          TagItem deleteTag = widget.passTagItem!;
          int deleteResult = await mySQF.deleteSelectedBudgetTag(deleteTag);
          SnackBar sbMsg = (deleteResult != 0)
              ? const SnackBar(
                  content: Text("Success => Successfully deleted!"))
              : const SnackBar(
                  content: Text("Error => Failed to delete budget tag!"));
          ScaffoldMessenger.of(context).showSnackBar(sbMsg);
          if (deleteResult != 0) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
        break;
      case ItemEnum.savingTag:
        if (kIsWeb) {
          Navigator.pop(context, true);
        } else {
          MySQFliteController mySQF = MySQFliteController();
          TagItem deleteTag = widget.passTagItem!;
          int deleteResult = await mySQF.deleteSelectedSavingTag(deleteTag);
          SnackBar sbMsg = (deleteResult != 0)
              ? const SnackBar(
                  content: Text("Success => Successfully deleted!"))
              : const SnackBar(
                  content: Text("Error => Failed to delete saving tag!"));
          ScaffoldMessenger.of(context).showSnackBar(sbMsg);
          if (deleteResult != 0) {
            Navigator.pop(context, true);
          } else {
            return;
          }
        }
        break;
    }
  }

  bool validate() {
    if ((widget.itemType == ItemEnum.budget) ||
        (widget.itemType == ItemEnum.saving)) {
      if (textAmountController.text.isEmpty) {
        SnackBar snackBar = const SnackBar(
            content: Text("Error => Amount entered is Empty!!!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      } else {
        double value = double.parse(textAmountController.text);
        if (value <= 0) {
          SnackBar snackBar = const SnackBar(
              content: Text("Error => Amount entered is less than 0!!"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          return true;
        }
      }
    } else if ((widget.itemType == ItemEnum.event) ||
        (widget.itemType == ItemEnum.budgetTag) ||
        (widget.itemType == ItemEnum.savingTag)) {
      if (textTitleController.text.isEmpty) {
        SnackBar snackBar =
            const SnackBar(content: Text("Error: => Title field is Empty!!!"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  String getTitle() {
    String title = "";
    switch (widget.manageType) {
      case ManageEnum.create:
        title += "Create ";
        break;
      case ManageEnum.edit:
        title += "Edit ";
        break;
      case ManageEnum.delete:
        title += "Delete ";
        break;
    }

    switch (widget.itemType) {
      case ItemEnum.budget:
        title += "Budget";
        break;
      case ItemEnum.saving:
        title += "Saving";
        break;
      case ItemEnum.event:
        title += "Event";
        break;
      case ItemEnum.budgetTag:
        title += "Budget Tag";
        break;
      case ItemEnum.savingTag:
        title += "Saving Tag";
        break;
    }

    return title;
  }

  void callCalendar() {
    showDialog(
        context: context,
        builder: (BuildContext context) => (AlertDialog(
              title: const Text('Navigation'),
              content: Container(
                width: 350,
                height: 400,
                padding: const EdgeInsets.all(4.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 01, 01),
                  lastDay: DateTime.utc(DateTime.now().year + 1,
                      DateTime.now().month, DateTime.now().day),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        textDateController.text =
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
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            )));
  }
}
