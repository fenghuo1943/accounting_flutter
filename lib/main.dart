import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:accounting/app/router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'model/transaction.dart';
import 'database/database_helper.dart';

void initializeDatabaseFactory() {
  databaseFactory = databaseFactoryFfi;
}
void main() async{
  // runApp(const MainApp());
  WidgetsFlutterBinding.ensureInitialized();
  initializeDatabaseFactory();
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // 初始化数据库
  initializeDatabaseFactory();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '记账软件',
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}
