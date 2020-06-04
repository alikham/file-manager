import 'dart:async';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/common.dart';
import 'package:flutter_file_manager/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future<void> getSDCardDir() async {
    Common().sDCardDir = await ExtStorage.getExternalStorageDirectory();
    print('ar main ${Common().sDCardDir}');
  }

  // Permission check
  Future<void> getPermission() async {
    if (Platform.isAndroid) {
      var storagePermissionStatus = await Permission.storage.isGranted;

      if (!storagePermissionStatus) {
        await Permission.storage.request();
      }

      await getSDCardDir();
    } else if (Platform.isIOS) {
      await getSDCardDir();
    }
  }

  Future.wait([initializeDateFormatting("zh_CN", null), getPermission()])
      .then((result) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Manager',
      theme: ThemeData(
//        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
      ),
      home: FileManager(),
    );
  }
}
