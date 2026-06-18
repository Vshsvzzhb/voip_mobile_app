import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_button.dart';
import '../../widgets/veten_text_field.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _nameCtrl = TextEditingController(
      text: DummyData.currentUser.name);
  late final _bioCtrl = TextEditingController(
      text: DummyData.currentUser.bio);
  late final _phoneCtrl = TextEditingController(
      text: DummyData.currentUser.phone);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Simpan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  VetenAvatar(
                    name: DummyData.currentUser.name,
                    imageUrl: DummyData.currentUser.avatarUrl,
                    size: 90,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Ubah Foto Profil',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            VetenTextField(
              label: 'Nama',
              controller: _nameCtrl,
              prefix: const Icon(Icons.person_outline_rounded,
                  color: AppColors.onSurfaceVariant, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            VetenTextField(
              label: 'Bio',
              controller: _bioCtrl,
              maxLines: 3,
              prefix: const Icon(Icons.info_outline_rounded,
                  color: AppColors.onSurfaceVariant, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            VetenTextField(
              label: 'Nomor Telepon',
              controller: _phoneCtrl,
              readOnly: true,
              prefix: const Icon(Icons.phone_outlined,
                  color: AppColors.onSurfaceVariant, size: 20),
            ),
            const SizedBox(height: AppSpacing.xl),
            VetenButton(
              label: 'Simpan Perubahan',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
