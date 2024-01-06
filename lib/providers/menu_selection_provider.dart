import 'package:flutter/material.dart';
import 'package:pokeme/enums/menu_type_enum.dart';

class MenuSelectionProvider extends ChangeNotifier {
  MenuTypeEnum menuTypeEnum;

  MenuSelectionProvider({
    required this.menuTypeEnum,
  });

  updateMenuSelectionProvider(MenuSelectionProvider menuSelectionProvider) {
    menuTypeEnum = menuSelectionProvider.menuTypeEnum;
    notifyListeners();
  }
}
