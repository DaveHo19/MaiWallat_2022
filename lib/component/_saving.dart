import '_itemComponent.dart';

class Saving{

  final int? id;
  final String tag;
  final double amount;
  final String dateTime;

  const Saving({
    this.id,
    required this.tag,
    required this.amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap(){
    return{
      //'id': id,
      'tag': tag,
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
    return 'Saving{id: $id, tag: $tag, amount: $amount, dateTime: $dateTime';
  }
}