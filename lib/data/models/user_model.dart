class UserModel {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final String bio;
  final bool isOnline;
  final DateTime lastSeen;
  final bool isGroup;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.bio,
    required this.isOnline,
    required this.lastSeen,
    this.isGroup = false,
  });
}
