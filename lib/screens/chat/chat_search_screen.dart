import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = DummyData.chats
        .where((c) =>
            c.contact.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.lastMessage.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.plusJakartaSans(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Cari pesan atau kontak...',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.onSurfaceVariant.withOpacity(0.6),
              fontSize: 15,
            ),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () => setState(() {
                _searchCtrl.clear();
                _query = '';
              }),
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_rounded,
                      size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Cari chat atau kontak',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : filtered.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada hasil untuk "$_query"',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final chat = filtered[i];
                    return ListTile(
                      leading: VetenAvatar(
                        name: chat.contact.name,
                        imageUrl: chat.contact.avatarUrl,
                        size: AppSpacing.avatarMd,
                      ),
                      title: Text(chat.contact.name),
                      subtitle: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => context.push('/chat/${chat.id}'),
                    );
                  },
                ),
    );
  }
}
