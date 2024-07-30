// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobigic_assignment/data/local%20database/local_db.dart';
import 'package:mobigic_assignment/data/logic/auth/logour_bloc.dart';
import 'package:mobigic_assignment/data/logic/auth/register_bloc.dart';
import 'package:mobigic_assignment/data/logic/files/bloc/get_files_bloc.dart';
import 'package:mobigic_assignment/data/logic/files/bloc/upload_files_bloc.dart';
import 'package:mobigic_assignment/views/auth/login_screen.dart';
import 'package:mobigic_assignment/views/dashboard/dashboard_screen.dart';

import 'data/logic/auth/login_bloc.dart';
import 'data/logic/files/bloc/file_action_bloc.dart';
import 'data/model/user model/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final userData = await LocalDatabase.getUserData();
  runApp(MyApp(
    userData: userData,
  ));
}

class MyApp extends StatelessWidget {
  final UserModel? userData;
  const MyApp({super.key, required this.userData});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => RegisterUserBloc()),
        BlocProvider(create: (context) => LogoutBloc()),
        BlocProvider(create: (context) => GetFilesBloc()),
        BlocProvider(create: (context) => FileActionBloc()),
        BlocProvider(create: (context) => UploadFilesBloc()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.9);
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
              child: child!);
        },
        title: 'File Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'FiraSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: userData != null
            ? DashboardScreen(
                userdata: userData!,
              )
            : const LoginScreen(),
      ),
    );
  }
}
