import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms_forwarder/models/app_parameters.dart';

const _urls = 'urls';

class ParametersService {
  /// Initialize Hive, open the [urls] box and retrieve the parameters
  static Future<AppParameters?> getStoredParameters() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(_urls);

    final map = Map<String, dynamic>.from(box.toMap());
    if (map.isEmpty) return null;

    return AppParameters.fromMap(map);
  }

  static Future<Box> openHiveBox() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(_urls);
    return box;
  }

  static ValueListenable<Box> getListenableBox() {
    return Hive.box(_urls).listenable();
  }

  static Future<void> saveParametersToBox(AppParameters parameters) async {
    await Hive.box(_urls).putAll(
      parameters.toMap(),
    );
  }
}
