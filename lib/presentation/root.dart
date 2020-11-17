import 'package:calculator/cubit/rebuild_fixer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Own importation
import 'screens/screen_manager.dart';

class AccountManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RebuildFixer(true),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreenManager(),
      ),
    );
  }
}
