import 'package:flutter/cupertino.dart';
import 'package:fuel_opt/model/search_result.dart';

class ResultList extends ChangeNotifier {
  List<StationResult?> resultList;

  ResultList({required this.resultList});
}
