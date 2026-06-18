import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = DummyData.contacts
        .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Kontak',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.onBackground,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.person_add_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/select-members'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.group_add_rounded, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.plusJakartaSans(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Cari kontak...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.onSurfaceVariant.withOpacity(0.6),
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.onSurfaceVariant),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                _QuickAction(
                  icon: Icons.person_add_rounded,
                  label: 'Tambah Kontak',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickAction(
                  icon: Icons.group_add_rounded,
                  label: 'Grup Baru',
                  color: AppColors.secondary,
                  onTap: () => context.push('/select-members'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _QuickAction(
                  icon: Icons.person_search_rounded,
                  label: 'Permintaan',
                  color: AppColors.tertiary,
                  onTap: () => context.push('/friend-requests'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(
                  indent: 76, height: 0, color: AppColors.outlineVariant),
              itemBuilder: (context, i) {
                final contact = filtered[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 4),
                  leading: VetenAvatar(
                    name: contact.name,
                    imageUrl: contact.avatarUrl,
                    size: AppSpacing.avatarMd,
                    showOnline: true,
                    isOnline: contact.isOnline,
                    isGroup: contact.isGroup,
                  ),
                  title: Text(contact.name),
                  subtitle: Text(
                    contact.bio,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call_rounded,
                            color: AppColors.primary, size: 20),
                        onPressed: () =>
                            context.push('/voice-call/${contact.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                            color: AppColors.secondary, size: 20),
                        onPressed: () {
                          // find chat with this contact
                          final chat = DummyData.chats.firstWhere(
                            (c) => c.contact.id == contact.id,
                            orElse: () => DummyData.chats.first,
                          );
                          context.push('/chat/${chat.id}');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
