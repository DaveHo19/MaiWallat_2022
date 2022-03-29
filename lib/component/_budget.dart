import '_itemComponent.dart';

class Budget{

  final int? id;
  final String tag;
  final String? description;
  final double amount;
  final String dateTime;

  const Budget({
    this.id,
    required this.tag,
    this.description,
    required this.amount,
    required this.dateTime
  });

  Map<String, dynamic> toMap(){
    return {
      //'id': id,
      'tag': tag,
      'description': description??"",
      'amount': amount,
      'dateTime': dateTime,
    };
  }

  ItemComponent toItemComponent(){
    String title = tag;
    String details = "Amount: " + amount.toStringAsFixed(2);
    return ItemComponent(title, details, dateTime);
  }

  @override
  String toString(){
    return 'Budget{id: $id, tag: $tag, description: $description, amount: $amount, dateTime: $dateTime}';
  }
}