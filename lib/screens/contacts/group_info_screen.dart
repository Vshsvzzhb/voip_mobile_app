import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/veten_button.dart';
import '../../widgets/veten_text_field.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Info Grup Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_a_photo_rounded,
                    color: AppColors.primary, size: 36),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            VetenTextField(
              label: 'Nama Grup',
              hint: 'Masukkan nama grup...',
              controller: _nameCtrl,
              prefix: const Icon(Icons.group_rounded,
                  color: AppColors.onSurfaceVariant, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            VetenTextField(
              label: 'Deskripsi (opsional)',
              hint: 'Tentang grup ini...',
              controller: _descCtrl,
              maxLines: 3,
              prefix: const Icon(Icons.description_outlined,
                  color: AppColors.onSurfaceVariant, size: 20),
            ),
            const Spacer(),
            VetenButton(
              label: 'Buat Grup',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
