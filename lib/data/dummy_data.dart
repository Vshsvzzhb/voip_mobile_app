import 'models/user_model.dart';
import 'models/chat_model.dart';
import 'models/call_model.dart';

class DummyData {
  DummyData._();

  static final UserModel currentUser = UserModel(
    id: 'me',
    name: 'Kamu',
    phone: '+62812345678',
    avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    bio: 'Halo! Saya menggunakan VetenCall.',
    isOnline: true,
    lastSeen: DateTime.now(),
  );

  static final List<UserModel> contacts = [];

  static List<ChatModel> get chats => [];

  static List<MessageModel> _generateMessages(String chatId, UserModel contact) {
    return [];
  }

  static final List<CallLogModel> callLogs = [];
}
