import 'package:intl/intl.dart';

import '_itemComponent.dart';

class Event{

  final int? id;
  final String title;
  final String? description;
  final String dateTime;
  final String duration;

  const Event({
    this.id,
    required this.title,
    this.description,
    required this.dateTime,
    required this.duration,
  });

  Map<String, dynamic> toMap(){
    return {
      //'id': id,
      'title': title,
      'description': description??"",
      'dateTime': dateTime,
      'duration': duration,
    };
  }

  ItemComponent toItemComponent(){
    return ItemComponent(title, description??"", dateTime);
  }

  @override
  String toString(){
    return 'Event{id: $id, title: $title, description: $description, dateTime: $dateTime, duration: $duration';
  }

}