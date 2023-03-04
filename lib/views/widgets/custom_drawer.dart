import 'package:flutter/material.dart';
import 'package:kanban_board_app/utils/shared_pref.dart';
import 'package:kanban_board_app/views/auth/loginpage.dart';
import 'package:kanban_board_app/services/theme/theme_services.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        // Thumb icon when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.dark_mode);
        }
        return const Icon(Icons.light_mode);
      },
    );
    final dataKey = GlobalKey();

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 100),
        children: [
          ListTile(
              title: const Text('Dark Theme'),
              trailing: Switch(
                value: ThemeService().loadThemeFromBox(),
                onChanged: (val) {
                  ThemeService().switchTheme();
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              )),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () {
              UserPreferences().reset();
              LocalStorageUtil.erase();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
