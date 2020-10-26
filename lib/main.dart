import 'package:flutter/material.dart';
import 'package:notekeeper/mulitselecthelper.dart';
import 'package:notekeeper/screens/home.dart';
import 'package:notekeeper/theme/AppStateNotifier.dart';
import 'package:notekeeper/theme/AppTheme.dart';
import 'package:provider/provider.dart';

main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: Consumer<AppStateNotifier>(
        builder: (context, appState, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.isDarkmodeOn ? ThemeMode.dark : ThemeMode.light,
            home: ChangeNotifierProvider<MultiSelectHelper>.value(
                value: MultiSelectHelper.multiselectinstance, child: Home()),
          );
        },
      ),
    ),
  );
}
