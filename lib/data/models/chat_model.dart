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

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.status,
    this.imageUrl,
    this.isDeleted = false,
  });
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
