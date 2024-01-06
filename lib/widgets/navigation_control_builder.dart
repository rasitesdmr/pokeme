import 'package:flutter/material.dart';
import 'package:pokeme/enums/menu_type_enum.dart';
import 'package:pokeme/providers/menu_selection_provider.dart';
import 'package:provider/provider.dart';

class NavigationControlBuilder {
  static Widget floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      tooltip: 'Increment',
      onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 28,
      ),
    );
  }

  static Widget bottomAppBar(BuildContext context) {
    final buttonBarInfo = Provider.of<MenuSelectionProvider>(context);
    return BottomAppBar(
      color: const Color(0xFF2D2F41),
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Dış kenar boşluğunu ayarla
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIconButton(
              icon: Icon(
                Icons.watch_later,
                size: 24,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.clock
                  ? Colors.blue
                  : Colors.white,
              label: 'Clock',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.clock);
              },
            ),
            buildIconButton(
              icon: Icon(Icons.alarm, size: 24),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.alarm
                  ? Colors.blue
                  : Colors.white,
              label: 'Alarm',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.alarm);
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildIconButton({
    required Widget icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
          color: color,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }

  static void updateMenu(BuildContext context, MenuTypeEnum menuTypeEnum) {
    var buttonBarInfo =
        Provider.of<MenuSelectionProvider>(context, listen: false);
    buttonBarInfo.updateMenuSelectionProvider(
        MenuSelectionProvider(menuTypeEnum: menuTypeEnum));
  }
}
