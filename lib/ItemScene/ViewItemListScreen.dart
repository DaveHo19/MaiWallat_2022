import 'package:expense_app/ItemScene/ViewItemScreen.dart';
import 'package:expense_app/component/_enumList.dart';
import 'package:expense_app/component/_event.dart';
import 'package:expense_app/component/_filterItem.dart';
import 'package:expense_app/component/_itemComponent.dart';
import 'package:expense_app/component/_saving.dart';
import 'package:expense_app/component/_tagItem.dart';
import 'package:expense_app/manager/SQFliteController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/component/_budget.dart';

class MyViewItemListScreen extends StatefulWidget {
  MyViewItemListScreen({
    Key? key,
    required this.itemType,
    this.selectedDate,
    // required this.isFilter,
    // this.filterItem}
  }) : super(key: key);

  final ItemEnum itemType;
  String? selectedDate;

  //final FilterItem? filterItem;
  //final bool isFilter;

  @override
  State<MyViewItemListScreen> createState() => _MyViewItemListScreenState();
}

class _MyViewItemListScreenState extends State<MyViewItemListScreen> {
  final TextEditingController textAmountMinController = TextEditingController();
  final TextEditingController textAmountMaxController = TextEditingController();
  final TextEditingController textDescController = TextEditingController();

  List<Budget> budgetList = <Budget>[];
  List<Saving> savingList = <Saving>[];
  List<Event> eventList = <Event>[];
  List<TagItem> tagList = <TagItem>[];

  List<Budget>? filterBudgetList;
  List<Saving>? filterSavingList;
  List<Event>? filterEventList;
  List<TagItem>? filterTagItemList;

  bool isSorting = false;
  late bool isViewAll;
  //String selectedItem = "All";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isViewAll = (widget.selectedDate != null) ? false : true;
    //generateTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        title: Text(generateTitle()),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(2.0),
              child: _buildFilterNav(context),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(2.0),
                child: _prepareListView(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterNav(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.sort,
            color: (isSorting) ? Colors.grey : Colors.orangeAccent ,
          ),
          onPressed: () => {
            isSorting = !isSorting,
            refreshContent(),
          },
        ),
        IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.view_list,
            color: (isViewAll) ? Colors.grey : Colors.orangeAccent,
          ),
          onPressed: () => {
            isViewAll = !isViewAll,
            changeDisplayCondition(),
          }
        ),
      ],
    );
  }

  Widget _prepareListView(BuildContext context) {
    return FutureBuilder<bool>(
        future: initializeList(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return _buildListView(context);
        });
  }

  Widget _buildListView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshContent,
      child: ListView.builder(
          itemCount: (widget.itemType == ItemEnum.budget)
                      ? !isViewAll
                      ? filterBudgetList?.length ?? 0 : budgetList.length
                      : (widget.itemType == ItemEnum.saving)
                      ? !isViewAll
                      ? filterSavingList?.length ?? 0 : savingList.length
                      : (widget.itemType == ItemEnum.event)
                      ? !isViewAll
                      ? filterEventList?.length ?? 0  : eventList.length
                      : (widget.itemType == ItemEnum.budgetTag || widget.itemType == ItemEnum.savingTag)
                      ? !isViewAll 
                      ? filterTagItemList?.length ?? 0: tagList.length
                      : 0,
          itemBuilder: (context, i) {
            return _buildListItemRow(
                (widget.itemType == ItemEnum.budget)
                  ? !isViewAll
                  ? filterBudgetList![i] : budgetList[i]
                  : (widget.itemType == ItemEnum.saving)
                  ? !isViewAll
                  ? filterSavingList![i] : savingList[i]
                  : (widget.itemType == ItemEnum.event)
                  ? !isViewAll
                  ? filterEventList![i] : eventList[i]
                  : (widget.itemType == ItemEnum.budgetTag || widget.itemType == ItemEnum.savingTag)
                  ? !isViewAll
                  ? filterTagItemList![i] : tagList[i]
                  : <Object>[],
                i,
                context);
          }),
    );
  }

  Widget _buildListItemRow(var item, int id, BuildContext context) {
    return ListTile(
      title: //Text(activity.title)
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("#" + (id + 1).toString()),
              (widget.itemType == ItemEnum.event)
                ? Text(item.title)
                : (widget.itemType == ItemEnum.budget || widget.itemType == ItemEnum.saving)
                ? Text(item.tag)
                : (widget.itemType == ItemEnum.budgetTag || widget.itemType == ItemEnum.savingTag)
                ? Text(item.name)
                : Container(),
              (widget.itemType == ItemEnum.event)
                  ? Text(item.dateTime)
                  : (widget.itemType == ItemEnum.budget || widget.itemType == ItemEnum.saving) 
                  ? Text(item.amount.toStringAsFixed(2))
                  : (widget.itemType == ItemEnum.budgetTag || widget.itemType == ItemEnum.savingTag)
                  ? Container() : Container(),
            ],
          ),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
      onTap: () => {goToViewDetailScreen(context, item)},
    );
  }

  void pass() {}

  void changeDisplayCondition(){
    setState(() {
    });
  }

  void goToViewDetailScreen(BuildContext context, var item) {
    switch (widget.itemType) {
      case ItemEnum.budget:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyViewItemDetailScene(
                  itemType: widget.itemType, passedBudget: item)),
        );
        break;
      case ItemEnum.saving:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyViewItemDetailScene(
                  itemType: widget.itemType, passedSaving: item)),
        );
        break;
      case ItemEnum.event:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyViewItemDetailScene(
                  itemType: widget.itemType, passedEvent: item)),
        );
        break;
      case ItemEnum.budgetTag:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyViewItemDetailScene(
                  itemType: widget.itemType, passedTag: item)),
        );
        break;
      case ItemEnum.savingTag:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyViewItemDetailScene(
                  itemType: widget.itemType, passedTag: item)),
        );
        break;
    }
  }



  Future<void> refreshContent() {
    setState(() {
      initializeList();
    });
    return Future.value(null);
  }

  Future<bool> initializeList() async {
    if (kIsWeb) {
      budgetList.clear();
      initializeTempList();
    } else {
      MySQFliteController mySQF = MySQFliteController();
      switch (widget.itemType) {
        case ItemEnum.budget:
          budgetList = await mySQF.retrieveBudgetList();
          budgetList = isSorting ? budgetList : budgetList.reversed.toList();
          if (!isViewAll) {
            filterBudgetList = budgetList
                .where((x) => x.dateTime == widget.selectedDate!)
                .toList();
          }
          break;
        case ItemEnum.saving:
          savingList = await mySQF.retrieveSavingList();
          savingList = isSorting ? savingList : savingList.reversed.toList();
          if (!isViewAll) {
            filterSavingList = savingList
                .where((x) => x.dateTime == widget.selectedDate!)
                .toList();
          }
          break;
        case ItemEnum.event:
          eventList = await mySQF.retrieveEventList();
          eventList = isSorting ? eventList : eventList.reversed.toList();
          if (!isViewAll) {
            filterEventList = eventList
                .where((x) => x.dateTime == widget.selectedDate!)
                .toList();
          }
          break;
        case ItemEnum.budgetTag:
          tagList = await mySQF.retrieveBudgetTagList();
          tagList = isSorting ? tagList : tagList.reversed.toList();
          if(!isViewAll){
            filterTagItemList = tagList;
          }
          break;
        case ItemEnum.savingTag:
          tagList = await mySQF.retrieveSavingTagList();
          tagList = isSorting ? tagList : tagList.reversed.toList();
           if(!isViewAll){
            filterTagItemList = tagList;
          }
          break;
      }
    }
    return true;
  }

  String generateTitle() {
    String title = "";
    switch (widget.itemType) {
      case ItemEnum.budget:
        title += "Budget ";
        break;
      case ItemEnum.saving:
        title += "Saving ";
        break;
      case ItemEnum.event:
        title += "Event ";
        break;
      case ItemEnum.budgetTag:
        title += "Budget Tag ";
        break;
      case ItemEnum.savingTag:
        title += "Saving Tag ";
        break;
    }

    title += "List";
    return title;
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

  // void generateTagList() {
  //   tagList.add("All");
  //   tagList.add("Food");
  //   tagList.add("Vehicles");
  //   tagList.add("Gift");
  //   tagList.add("Bills");
  //   tagList.add("Other");
  // }

  // void filterAction(FilterItem filterItem, FilterEnum filterType) {

  //   List<Budget> tempBudgetList = <Budget>[];
  //   List<Saving> tempSavingList = <Saving>[];
  //   List<Event> tempEventList = <Event>[];

  //   switch (widget.itemType) {
  //     case ItemEnum.budget:
  //         tempBudgetList = budgetList;
  //         switch(filterType){
  //           case FilterEnum.and:
  //             if((filterItem.tag != null) && tempBudgetList.isNotEmpty){
  //               filterBudgetList = tempBudgetList.where((x) => x.tag == x.tag).toList();
  //               tempBudgetList = filterBudgetList?? <Budget>[];
  //             }
  //             else{
  //               filterBudgetList = <Budget>[];
  //             }
  //             if((filterItem.description != null) && tempBudgetList.isNotEmpty){
  //               filterBudgetList = tempBudgetList.where((x) => x.description!.contains(x.description??"")).toList();
  //               tempBudgetList = filterBudgetList?? <Budget>[];
  //             } else{
  //               filterBudgetList = <Budget>[];
  //             }
  //             if((filterItem.exactAmount != null) && tempBudgetList.isNotEmpty){
  //               filterBudgetList = tempBudgetList.where((x) => x.amount == filterItem.exactAmount).toList();
  //               tempBudgetList = filterBudgetList?? <Budget>[];
  //             } else{
  //               filterBudgetList = <Budget>[];
  //             }
  //             if(filterItem.amountRange && tempBudgetList.isNotEmpty){
  //               if(filterItem.minAmount == 0){
  //                 filterBudgetList = tempBudgetList.where((x) => x.amount <= filterItem.maxAmount!).toList();
  //               } else if (filterItem.maxAmount == 0){
  //                 filterBudgetList = tempBudgetList.where((x) => x.amount >= filterItem.minAmount!).toList();
  //               } else {
  //                 filterBudgetList = tempBudgetList.where((x) => (x.amount >= filterItem.minAmount! && x.amount <= filterItem.maxAmount!)).toList();
  //               }
  //               tempBudgetList = filterBudgetList?? <Budget>[];
  //             } else{
  //               filterBudgetList = <Budget>[];
  //             }
  //             if((filterItem.exactDateTime != null) && tempBudgetList.isNotEmpty){
  //               filterBudgetList = tempBudgetList.where((x) => x.dateTime == filterItem.exactDateTime).toList();
  //               tempBudgetList = filterBudgetList?? <Budget>[];
  //             }else{
  //               filterBudgetList = <Budget>[];
  //             }
  //             if (filterItem.dateRange && tempBudgetList.isNotEmpty){
  //               DateTime sDT = DateFormat("yyyy-MM-dd").parse(filterItem.startDateTime!);
  //               DateTime eDT = DateFormat("yyyy-MM-dd").parse(filterItem.lastDateTime!);
  //               // filterBudgetList = tempBudgetList.where((x) =>
  //               //   DateFormat.x
  //               // )
  //             }
  //             break;

  //         }
  //       break;
  //     case ItemEnum.saving:

  //       tempSavingList = savingList;
  //       break;
  //     case ItemEnum.event:
  //       tempEventList = eventList;
  //       break;
  //     case ItemEnum.budgetTag:
  //       //tempList = tagList;
  //       break;
  //     case ItemEnum.savingTag:
  //       //tempList = tagList;
  //       break;
  //   }
  // }
  // Widget _buildFilterComponent(BuildContext context) {
  //   return
  //       // Container(
  //       //   width: MediaQuery.of(context).size.width / 1.5,
  //       //   height: MediaQuery.of(context).size.height / 1.5,
  //       //   child:
  //       Column(mainAxisAlignment: MainAxisAlignment.start, children: [
  //     //Expanded(flex: 1, child: _buildTagFilter(context)),
  //     Expanded(
  //       flex: 1,
  //       child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
  //         _buildAmountMinInputFilter(context),
  //         _buildAmountMaxInputFilter(context)
  //       ]),
  //     ),
  //     Expanded(flex: 1, child: _buildDescriptionInputFilter(context)),
  //     Expanded(flex: 1, child: _buildFilterButton(context)),
  //     // _buildTagFilter(context),
  //     // Row(
  //     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     //     children: [
  //     //     _buildAmountMinInputFilter(context),
  //     //     _buildAmountMaxInputFilter(context)]
  //     // ),
  //     // _buildDescriptionInputFilter(context),
  //     // _buildFilterButton(context),
  //   ]
  //           //),
  //           );
  // }

  //   void showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text("Filter"),
  //       content: Container(
  //         width: MediaQuery.of(context).size.width / 1.2,
  //         height: MediaQuery.of(context).size.height / 1.2,
  //         // width: 400,
  //         // height: 600,
  //         padding: const EdgeInsets.all(4.0),
  //         //child: _buildFilterComponent(context),
  //       ),
  //     ),
  //   );
  // }
  
  // Widget _buildTagFilter(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 2,
  //     padding: const EdgeInsets.all(1.0),
  //     child: DropdownButtonFormField(
  //       decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           labelText: "Tag",
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           floatingLabelAlignment: FloatingLabelAlignment.start),
  //       icon: const Icon(Icons.arrow_drop_down),
  //       isExpanded: true,
  //       value: selectedItem,
  //       elevation: 8,
  //       alignment: Alignment.center,
  //       onChanged: (String? newvalue) {
  //         setState(() {
  //           selectedItem = newvalue!;
  //         });
  //       },
  //       items: tagList.map<DropdownMenuItem<String>>((String va) {
  //         return DropdownMenuItem<String>(
  //           value: va,
  //           child: Text(va),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
 // Widget _buildAmountMinInputFilter(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 4,
  //     padding: const EdgeInsets.all(1.0),
  //     child: TextField(
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         labelText: "Min Amount",
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         floatingLabelAlignment: FloatingLabelAlignment.start,
  //         hintText: "Enter amount",
  //       ),
  //       keyboardType: TextInputType.number,
  //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //       controller: textAmountMinController,
  //     ),
  //   );
  // }

  // Widget _buildAmountMaxInputFilter(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 4,
  //     padding: const EdgeInsets.all(1.0),
  //     child: TextField(
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         labelText: "Max Amount",
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         floatingLabelAlignment: FloatingLabelAlignment.start,
  //         hintText: "Enter amount",
  //       ),
  //       keyboardType: TextInputType.number,
  //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //       controller: textAmountMaxController,
  //     ),
  //   );
  // }

  // Widget _buildDescriptionInputFilter(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 2,
  //     padding: const EdgeInsets.all(1.0),
  //     child: TextField(
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         labelText: "Description",
  //         floatingLabelBehavior: FloatingLabelBehavior.always,
  //         floatingLabelAlignment: FloatingLabelAlignment.start,
  //         hintText: 'Enter description',
  //       ),
  //       keyboardType: TextInputType.text,
  //       maxLines: 5,
  //       controller: textDescController,
  //     ),
  //   );
  // }

  // Widget _buildFilterButton(BuildContext context) {
  //   return Container();
  // }
 

}
