import 'package:flutter/material.dart';
import 'package:pokeme/enums/menu_type_enum.dart';
import 'package:pokeme/providers/menu_selection_provider.dart';
import 'package:provider/provider.dart';
import 'package:pokeme/styles/app_color_palette.dart';

class NavigationControlBuilder {
  static Widget floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColorPalette.menuBackgroundColor,
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
      color: AppColorPalette.menuBackgroundColor,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Dış kenar boşluğunu ayarla
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIconButton(
              icon: Icon(
                Icons.book,
                size: 28,
                color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.pomodoro
                    ? AppColorPalette.menuSelectedItemColor
                    : AppColorPalette.menuUnselectedItemColor,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.pomodoro
                  ? AppColorPalette.menuSelectedItemColor
                  : AppColorPalette.menuUnselectedItemColor,
              label: 'Pomodoro',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.pomodoro);
              },
            ),
            buildIconButton(
              icon: Icon(
                Icons.alarm,
                size: 28,
                color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.alarm
                    ? AppColorPalette.menuSelectedItemColor
                    : AppColorPalette.menuUnselectedItemColor,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.alarm
                  ? AppColorPalette.menuSelectedItemColor
                  : AppColorPalette.menuUnselectedItemColor,
              label: '  Alarm ',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.alarm);
              },
            ),
            buildIconButton(
              icon: Icon(
                Icons.today_sharp,
                size: 28,
                color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.todo
                    ? AppColorPalette.menuSelectedItemColor
                    : AppColorPalette.menuUnselectedItemColor,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.todo
                  ? AppColorPalette.menuSelectedItemColor
                  : AppColorPalette.menuUnselectedItemColor,
              label: '  Todo  ',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.todo);
              },
            ),
            buildIconButton(
              icon: Icon(
                Icons.watch_later,
                color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.clock
                    ? AppColorPalette.menuSelectedItemColor
                    : AppColorPalette.menuUnselectedItemColor,
                size: 28,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.clock
                  ? AppColorPalette.menuSelectedItemColor
                  : AppColorPalette.menuUnselectedItemColor,
              label: ' Clock  ',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.clock);
              },
            ),
            buildIconButton(
              icon: Icon(
                Icons.storefront,
                size: 28,
                color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.stopwatch
                    ? AppColorPalette.menuSelectedItemColor
                    : AppColorPalette.menuUnselectedItemColor,
              ),
              color: buttonBarInfo.menuTypeEnum == MenuTypeEnum.stopwatch
                  ? AppColorPalette.menuSelectedItemColor
                  : AppColorPalette.menuUnselectedItemColor,
              label: 'StopWatch',
              onPressed: () {
                updateMenu(context, MenuTypeEnum.stopwatch);
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
        InkResponse(
          onTap: onPressed,
          child: Padding(
            padding:
                const EdgeInsets.all(4.0), // Gerektiği kadar padding ekleyin
            child: icon,
          ),
          highlightColor: Colors.transparent,
          splashColor: AppColorPalette.menuSelectedItemColor,
          radius: 10.0,
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
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
