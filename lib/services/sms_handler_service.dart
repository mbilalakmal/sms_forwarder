import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sms_forwarder/models/app_parameters.dart';
import 'package:sms_forwarder/models/message_model.dart';

class SmsHandlerService {
  static Future<void> postSms({
    required AppParameters parameters,
    required MessageModel message,
  }) async {
    final url = Uri.parse(parameters.smsUrl);

    /// Convert message to map and add the apiKey
    final body = message.toMap();
    body['key'] = parameters.apiKey;

    try {
      final response = await http.post(url, body: jsonEncode(body));

      /// If response is 2xx, send a GET request to health ok
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final okUrl = Uri.parse(parameters.healthCheckUrlOk);
        await http.get(okUrl);
      } else {
        final failUrl = Uri.parse(parameters.healthCheckUrlFail);
        await http.get(failUrl);
      }
    } on Exception catch (e) {
      print(e.toString());

      final failUrl = Uri.parse(parameters.healthCheckUrlFail);
      await http.get(failUrl);
    }
  }
}
