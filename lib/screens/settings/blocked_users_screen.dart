import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final _blocked = [DummyData.contacts[4], DummyData.contacts[6]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pengguna Diblokir (${_blocked.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _blocked.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.block_rounded,
                      size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: AppSpacing.md),
                  Text('Tidak ada pengguna yang diblokir',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 15, color: AppColors.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _blocked.length,
              separatorBuilder: (_, __) => const Divider(
                  indent: 76, height: 0, color: AppColors.outlineVariant),
              itemBuilder: (context, i) {
                final user = _blocked[i];
                return ListTile(
                  leading: VetenAvatar(
                      name: user.name,
                      imageUrl: user.avatarUrl,
                      size: AppSpacing.avatarMd),
                  title: Text(user.name),
                  subtitle: const Text('Diblokir'),
                  trailing: OutlinedButton(
                    onPressed: () => setState(() => _blocked.remove(user)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                    child: const Text('Buka Blokir'),
                  ),
                );
              },
            ),
    );
  }
}
