import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:sms_forwarder/models/app_parameters.dart';
import 'package:sms_forwarder/pages/home_page.dart';
import 'package:sms_forwarder/services/parameters_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<bool>(
      create: (context) {
        return ParametersService.openHiveBox().then((_) => true);
      },
      initialData: false,
      lazy: false,
      child: MaterialApp(
        title: 'SMS Forwarder',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const HomePageBuilder(),
      ),
      builder: (context, child) {
        final isOpened = context.watch<bool>();
        if (isOpened == false) return child!;

        return ValueListenableBuilder<Box>(
          valueListenable: ParametersService.getListenableBox(),
          child: child,
          builder: (context, box, child) {
            final map = Map<String, dynamic>.from(box.toMap());
            final parameters = map.isEmpty ? null : AppParameters.fromMap(map);

            return Provider<AppParameters?>.value(
              value: parameters,
              child: child,
            );
          },
        );
      },
    );
  }
}
