import 'package:expense_app/component/_itemComponent.dart';
import 'package:flutter/material.dart';

class TagItem{

  final int? id;
  final String name;

  const TagItem({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap(){
    return {
      'name': name,
    };
  }

  @override
  String toString(){
    return 'TagItem(id: $id, name: $name)';
  }

}