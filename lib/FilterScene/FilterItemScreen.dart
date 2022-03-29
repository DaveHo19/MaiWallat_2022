// import 'package:expense_app/BudgetScene/ViewBudgetDetailsScreen.dart';
// import 'package:expense_app/component/_enumList.dart';
// import 'package:expense_app/component/_tagItem.dart';
// import 'package:expense_app/component/_budget.dart';
// import 'package:expense_app/manager/SQFliteController.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:intl/intl.dart';

// class MyFilterBudgetScreen extends StatefulWidget {
//   const MyFilterBudgetScreen(
//       {Key? key, required this.type})
//       : super(key: key);

//   final ManageEnum type;

//   @override
//   State<MyFilterBudgetScreen> createState() => _MyFilterBudgetScreenState();
// }

// class _MyFilterBudgetScreenState extends State<MyFilterBudgetScreen> {
//   final textAmountMinController = TextEditingController();
//   final textAmountMaxController = TextEditingController();
//   final textDescController = TextEditingController();
//   final textTitleController = TextEditingController();


//   var tagList = <String>[];
//   String? selectedItem;
//   double amount = 0;

//   @override
//   void initState() {
//     GenerateTag();
//     //selectedItem = tagList.first;
//     //initialSelectedItem();

//   }

//   @override
//   void dispose() {
//     textAmountMinController.dispose();
//     textAmountMaxController.dispose();
//     textDescController.dispose();
//     textTitleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         Navigator.pop(context, false);
//         return Future.value(false);
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             //backgroundColor: Colors.deepOrangeAccent,
//             backgroundColor: Colors.black,
//             foregroundColor: Colors.white,
//             title: Text(getTitle() + " Budget"),
//           ),
//           body: SafeArea(child: _buildContent(context))),
//     );
//   }


//   Widget _buildContent(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 1,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(8.0),
//             child: _buildHeading(context),
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(8.0),
//             child: _buildTagSelection(context),
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(8.0),
//             child: _buildAmountInputField(context),
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: (MediaQuery.of(context).size.height / 9) * 3,
//             padding: const EdgeInsets.all(8.0),
//             child: _buildDescriptionInputField(context),
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: (MediaQuery.of(context).size.height / 9),
//             padding: const EdgeInsets.all(8.0),
//             child: _buildButton(context),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeading(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.all(4.0),
//       child: Text(
//         "Filter " + getTitle(), //text
//         textAlign: TextAlign.justify,
//         style: const TextStyle(
//           fontSize: 20,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildTagSelection(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 1.5,
//       padding: const EdgeInsets.all(4.0),
//       child: DropdownButtonFormField(
//         decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: "Tag",
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             floatingLabelAlignment: FloatingLabelAlignment.start),
//         icon: const Icon(Icons.arrow_drop_down),
//         isExpanded: true,
//         value: selectedItem,
//         elevation: 8,
//         alignment: Alignment.center,
//         onChanged: (widget.type == ManageEnum.delete)
//             ? null
//             : (String? newvalue) {
//                 setState(() {
//                   selectedItem = newvalue;
//                 });
//               },
//         items: tagList.map<DropdownMenuItem<String>>((String va) {
//           return DropdownMenuItem<String>(
//             value: va,
//             child: Text(va),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildAmountInputField(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 1.5,
//       padding: const EdgeInsets.all(4.0),
//       child: TextField(
//         decoration: const InputDecoration(
//           border: OutlineInputBorder(),
//           labelText: "Amount",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           floatingLabelAlignment: FloatingLabelAlignment.start,
//           hintText: "Enter amount",
//         ),
//         keyboardType: TextInputType.number,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         controller: textAmountController,
//         //initialValue: (widget.type == ManageEnum.create) ? 0.toStringAsFixed(2) : widget.passItem!.amount.toStringAsFixed(2),
//         readOnly: (widget.type == ManageEnum.delete),
//       ),
//     );
//   }

//   Widget _buildDescriptionInputField(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 1.5,
//       padding: const EdgeInsets.all(4.0),
//       child: TextField(
//         decoration: const InputDecoration(
//           border: OutlineInputBorder(),
//           labelText: "Description",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           floatingLabelAlignment: FloatingLabelAlignment.start,
//           hintText: 'Enter description',
//         ),
//         keyboardType: TextInputType.text,
//         maxLines: 5,
//         controller: textDescController,
//         //initialValue: (widget.type == ManageEnum.create) ? "" : widget.passItem!.description,
//         readOnly: (widget.type == ManageEnum.delete),
//       ),
//     );
//   }

//   Widget _buildButton(BuildContext context) {
//     return Center(
//       child: (widget.type == ManageEnum.delete)
//           ? GFButton(
//               text: "Delete",
//               size: GFSize.LARGE,
//               icon: const Icon(
//                 Icons.delete_outline,
//                 color: Colors.white,
//                 size: GFSize.MEDIUM,
//               ),
//               color: Colors.black,
//               onPressed: pass,
//             )
//           : GFButton(
//               text: (widget.type == ManageEnum.create) ? 'Save' : 'Update',
//               size: GFSize.LARGE,
//               icon: (widget.type == ManageEnum.create)
//                   ? const Icon(
//                       Icons.save_outlined,
//                       color: Colors.white,
//                       size: GFSize.MEDIUM,
//                     )
//                   : const Icon(
//                       Icons.edit_outlined,
//                       color: Colors.white,
//                       size: GFSize.MEDIUM,
//                     ),
//               color: Colors.black,
//               onPressed: pass,
//             ),
//     );
//   }

//   void GenerateTag() {
//     tagList.add("Food");
//     tagList.add("Vehicles");
//     tagList.add("Gift");
//     tagList.add("Bills");
//     tagList.add("Other");
//   }

//   void pass() {}

//   String getTitle() {
//     switch (widget.type) {
//       case ManageEnum.create:
//         return "Create";
//       case ManageEnum.edit:
//         return "Edit";
//       case ManageEnum.delete:
//         return "Delete";
//       default:
//         return "";
//     }
//   }


// }
