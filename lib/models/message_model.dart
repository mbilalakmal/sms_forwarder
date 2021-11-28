import 'package:flutter/foundation.dart';

@immutable
class MessageModel {
  final String sender;
  final String text;
  final DateTime timestamp;

  const MessageModel({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      sender: data['sender'],
      text: data['text'],
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toUtc().toIso8601String()
    };
  }
}
