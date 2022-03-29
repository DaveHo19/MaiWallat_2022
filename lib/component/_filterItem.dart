class FilterItem{

  String? tag;
  String? title;
  String? description;
  String? exactDateTime;
  String? startDateTime;
  String? lastDateTime;
  double? exactAmount;
  double? minAmount;
  double? maxAmount;

  bool amountRange = false;
  bool dateRange = false;

  FilterItem(String? sTag, String? sTitle, String? desc, 
            String? eDT, String? sDT, String? lDT, 
            double? eAmt, double? minAmt, double? maxAmt,
            bool? amtRange, bool? dtRange){
  
    tag = sTag;
    title = sTitle;
    description = desc;
    exactDateTime = eDT;
    startDateTime = sDT;
    lastDateTime = lDT;
    exactAmount = eAmt;
    minAmount = minAmt;
    maxAmount = maxAmt;
    amountRange = amtRange??false;
    dateRange = dtRange??false;
  }


}