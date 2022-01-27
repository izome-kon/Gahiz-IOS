import 'package:flutter/cupertino.dart';

class Settings extends ChangeNotifier {
  int pageIndex = 0;
  PageController navBarcontroller = new PageController();

  changePageIndex(index) {
    pageIndex = index;
    navBarcontroller.jumpToPage(pageIndex);
    notifyListeners();
  }
}
