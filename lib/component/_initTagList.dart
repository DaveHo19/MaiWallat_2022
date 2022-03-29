import 'package:expense_app/component/_tagItem.dart';

class InitTagList{
    
    List<TagItem> initBudgetTag = <TagItem>[];
    List<TagItem> initSavingTag = <TagItem>[];

    InitTagList(){
      initBudgetTag.add(const TagItem(name: "Other"));
      initBudgetTag.add(const TagItem(name: "Food"));
      initBudgetTag.add(const TagItem(name: "Bill"));
      initBudgetTag.add(const TagItem(name: "Vehicle"));
      initBudgetTag.add(const TagItem(name: "Gift"));

      initSavingTag.add(const TagItem(name: "Other"));
      initSavingTag.add(const TagItem(name: "Salary"));
      initSavingTag.add(const TagItem(name: "Bonus"));
      initSavingTag.add(const TagItem(name: "Gift"));
    }

    List<String> getBudgetTagList(){
      List<String> items = <String>[];

      initBudgetTag.forEach((element) {
        items.add(element.name);
      });
      return items;
    }
    List<String> getSavingTagList(){
      List<String> items = <String>[];

      initSavingTag.forEach((element) {
        items.add(element.name);
      });
      return items;
    }
}