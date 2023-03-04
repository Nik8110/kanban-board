import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/services/auth_bloc/auth_bloc.dart';
import 'package:kanban_board_app/services/theme/theme_services.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';
import 'package:kanban_board_app/utils/shared_pref.dart';
import 'package:kanban_board_app/views/splash_screen.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put(BoardController());
  UserPreferences().init();
  final uid = await LocalStorageUtil.read("userId");
  runApp(MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],
      child: MyApp(
        uid: uid,
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.uid});

  final String? uid;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kanban Board',
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.deepPurple,
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.light,
          useMaterial3: true),
      darkTheme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          primarySwatch: Colors.deepPurple,
          useMaterial3: true),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      enableLog: false,
      home: SplashScreen(uid: widget.uid ?? ""),
    );
  }
}
