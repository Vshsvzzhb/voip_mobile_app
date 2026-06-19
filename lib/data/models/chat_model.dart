import 'user_model.dart';

enum MessageStatus { sending, sent, delivered, read, failed }

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime time;
  final MessageStatus status;
  final String? imageUrl;
  final bool isDeleted;
  final String? reaction;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.status,
    this.imageUrl,
    this.isDeleted = false,
    this.reaction,
  });

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? time,
    MessageStatus? status,
    String? imageUrl,
    bool? isDeleted,
    String? reaction,
    bool clearReaction = false,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      time: time ?? this.time,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      isDeleted: isDeleted ?? this.isDeleted,
      reaction: clearReaction ? null : (reaction ?? this.reaction),
    );
  }
}

class ChatModel {
  final String id;
  final UserModel contact;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<MessageModel> messages;
  final bool isGroup;
  final bool isMuted;
  final bool isPinned;

  const ChatModel({
    required this.id,
    required this.contact,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.messages,
    this.isGroup = false,
    this.isMuted = false,
    this.isPinned = false,
  });
}
