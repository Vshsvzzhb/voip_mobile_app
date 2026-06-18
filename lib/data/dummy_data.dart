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

  static final List<UserModel> contacts = [
    UserModel(
      id: 'u1',
      name: 'Budi Santoso',
      phone: '+62811111111',
      avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
      bio: 'Dokter Umum | RSUD Kota',
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    UserModel(
      id: 'u2',
      name: 'Sari Dewi',
      phone: '+62822222222',
      avatarUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
      bio: 'Perawat ICU',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserModel(
      id: 'u3',
      name: 'Ahmad Rizky',
      phone: '+62833333333',
      avatarUrl: 'https://randomuser.me/api/portraits/men/7.jpg',
      bio: 'Apotek 24 Jam',
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    UserModel(
      id: 'u4',
      name: 'Tim Medis Grup',
      phone: '',
      avatarUrl: 'https://ui-avatars.com/api/?name=Tim+Medis+Grup&background=random',
      bio: 'Grup 5 anggota',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
      isGroup: true,
    ),
    UserModel(
      id: 'u5',
      name: 'Dr. Lisa Putri',
      phone: '+62844444444',
      avatarUrl: 'https://randomuser.me/api/portraits/women/11.jpg',
      bio: 'Spesialis Anak - RSIA Harapan',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserModel(
      id: 'u6',
      name: 'Eko Prabowo',
      phone: '+62855555555',
      avatarUrl: 'https://randomuser.me/api/portraits/men/13.jpg',
      bio: 'Kesehatan itu investasi terbaik!',
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    UserModel(
      id: 'u7',
      name: 'Dian Rahayu',
      phone: '+62866666666',
      avatarUrl: 'https://randomuser.me/api/portraits/women/15.jpg',
      bio: 'Bidan desa Maju Jaya',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  static List<ChatModel> get chats => [
    ChatModel(
      id: 'c1',
      contact: contacts[0],
      lastMessage: 'Baik Dok, terima kasih konsultasinya 🙏',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      messages: _generateMessages('c1', contacts[0]),
    ),
    ChatModel(
      id: 'c2',
      contact: contacts[1],
      lastMessage: 'Hasil lab sudah saya kirim ya',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      messages: _generateMessages('c2', contacts[1]),
    ),
    ChatModel(
      id: 'c3',
      contact: contacts[3],
      lastMessage: 'Rapat besok jam 9 pagi di ruang rapat',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 5,
      messages: _generateMessages('c3', contacts[3]),
      isGroup: true,
    ),
    ChatModel(
      id: 'c4',
      contact: contacts[2],
      lastMessage: 'Stok obat sudah tersedia kembali',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 6)),
      unreadCount: 0,
      messages: _generateMessages('c4', contacts[2]),
    ),
    ChatModel(
      id: 'c5',
      contact: contacts[4],
      lastMessage: 'Nanti sore ada pasien baru ya Dok',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      messages: _generateMessages('c5', contacts[4]),
    ),
  ];

  static List<MessageModel> _generateMessages(String chatId, UserModel contact) {
    final now = DateTime.now();
    return [
      MessageModel(
        id: '${chatId}m1',
        senderId: contact.id,
        text: 'Halo, selamat pagi! Ada yang bisa dibantu?',
        time: now.subtract(const Duration(hours: 2)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m2',
        senderId: 'me',
        text: 'Pagi! Saya ingin konsultasi mengenai kondisi pasien saya.',
        time: now.subtract(const Duration(hours: 1, minutes: 58)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m3',
        senderId: contact.id,
        text: 'Tentu, silakan ceritakan keluhannya.',
        time: now.subtract(const Duration(hours: 1, minutes: 55)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m4',
        senderId: 'me',
        text: 'Pasien mengalami demam tinggi sejak 3 hari lalu. Sudah diberi paracetamol tapi belum turun.',
        time: now.subtract(const Duration(hours: 1, minutes: 50)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m5',
        senderId: contact.id,
        text: 'Perlu diperiksa lebih lanjut. Apakah ada gejala lain seperti batuk atau nyeri?',
        time: now.subtract(const Duration(hours: 1, minutes: 45)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m6',
        senderId: 'me',
        text: 'Ada sedikit batuk dan sakit kepala. Tidak ada ruam atau gejala lainnya.',
        time: now.subtract(const Duration(hours: 1, minutes: 40)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m7',
        senderId: contact.id,
        text: 'Coba lakukan tes darah lengkap untuk memastikan diagnosis. Saya rekomendasikan ke lab terdekat.',
        time: now.subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '${chatId}m8',
        senderId: 'me',
        text: 'Baik Dok, terima kasih konsultasinya 🙏',
        time: now.subtract(const Duration(minutes: 5)),
        status: MessageStatus.delivered,
      ),
    ];
  }

  static final List<CallLogModel> callLogs = [
    CallLogModel(
      id: 'cl1',
      contact: contacts[0],
      type: CallType.voiceOutgoing,
      duration: const Duration(minutes: 12, seconds: 34),
      time: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    CallLogModel(
      id: 'cl2',
      contact: contacts[1],
      type: CallType.videoIncoming,
      duration: const Duration(minutes: 5, seconds: 10),
      time: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    CallLogModel(
      id: 'cl3',
      contact: contacts[2],
      type: CallType.voiceMissed,
      duration: Duration.zero,
      time: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    CallLogModel(
      id: 'cl4',
      contact: contacts[4],
      type: CallType.videoOutgoing,
      duration: const Duration(minutes: 23, seconds: 45),
      time: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CallLogModel(
      id: 'cl5',
      contact: contacts[5],
      type: CallType.voiceIncoming,
      duration: const Duration(minutes: 3, seconds: 22),
      time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    CallLogModel(
      id: 'cl6',
      contact: contacts[0],
      type: CallType.videoMissed,
      duration: Duration.zero,
      time: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}
