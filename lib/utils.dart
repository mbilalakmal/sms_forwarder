import 'package:sms_forwarder/models/message_model.dart';
import 'package:telephony/telephony.dart';

extension MessageParsing on MessageModel {
  static MessageModel fromSmsMessage(SmsMessage sms) {
    return MessageModel(
      sender: sms.address ?? 'Unknown',
      text: sms.body ?? 'Empty body',
      timestamp: sms.date != null
          ? DateTime.fromMillisecondsSinceEpoch(sms.date!)
          : DateTime.now(),
    );
  }
}

class Validator {
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) return 'URL can\'t be empty';

    final uri = Uri.tryParse(value);
    if (uri == null ||
        (uri.isScheme('https') == false && uri.isScheme('http') == false)) {
      return 'Invalid URL';
    }

    return null;
  }
}
