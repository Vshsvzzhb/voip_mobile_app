import 'user_model.dart';

enum CallType {
  voiceIncoming,
  voiceOutgoing,
  voiceMissed,
  videoIncoming,
  videoOutgoing,
  videoMissed,
}

class CallLogModel {
  final String id;
  final UserModel contact;
  final CallType type;
  final Duration duration;
  final DateTime time;

  const CallLogModel({
    required this.id,
    required this.contact,
    required this.type,
    required this.duration,
    required this.time,
  });

  bool get isVideo => type == CallType.videoIncoming ||
      type == CallType.videoOutgoing ||
      type == CallType.videoMissed;

  bool get isMissed => type == CallType.voiceMissed || type == CallType.videoMissed;

  bool get isIncoming => type == CallType.voiceIncoming || type == CallType.videoIncoming;
}
