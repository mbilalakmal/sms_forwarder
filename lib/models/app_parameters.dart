import 'package:flutter/foundation.dart';

@immutable
class AppParameters {
  final String apiKey;
  final String smsUrl;
  final String healthCheckUrlOk;
  final String healthCheckUrlFail;

  final bool serviceEnabled;

  const AppParameters({
    required this.apiKey,
    required this.smsUrl,
    required this.healthCheckUrlOk,
    required this.healthCheckUrlFail,
    required this.serviceEnabled,
  });

  factory AppParameters.fromMap(Map<String, dynamic> data) {
    print(data);
    return AppParameters(
      apiKey: data['apiKey'],
      smsUrl: data['smsUrl'],
      healthCheckUrlOk: data['healthCheckUrlOk'],
      healthCheckUrlFail: data['healthCheckUrlFail'],
      serviceEnabled: data['serviceEnabled'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'smsUrl': smsUrl,
      'healthCheckUrlOk': healthCheckUrlOk,
      'healthCheckUrlFail': healthCheckUrlFail,
      'serviceEnabled': serviceEnabled,
    };
  }
}
