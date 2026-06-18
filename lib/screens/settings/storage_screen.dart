import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Penyimpanan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              border: Border.all(color: AppColors.outlineVariant, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penggunaan Penyimpanan',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                const _StorageBar(items: [
                  _StorageItem('Foto & Video', 0.45, AppColors.primary),
                  _StorageItem('Dokumen', 0.2, AppColors.secondary),
                  _StorageItem('Audio', 0.1, AppColors.tertiary),
                  _StorageItem('Lainnya', 0.05, AppColors.onSurfaceVariant),
                ]),
                const SizedBox(height: AppSpacing.md),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LegendItem('Foto & Video', AppColors.primary, '452 MB'),
                    _LegendItem('Dokumen', AppColors.secondary, '201 MB'),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _LegendItem('Audio', AppColors.tertiary, '98 MB'),
                    _LegendItem('Lainnya', AppColors.onSurfaceVariant, '46 MB'),
                  ],
                ),
                const Divider(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total terpakai',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('797 MB / 2 GB',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _StorageTile(
            icon: Icons.photo_library_rounded,
            color: AppColors.primary,
            title: 'Foto & Video',
            size: '452 MB',
            onClear: () {},
          ),
          _StorageTile(
            icon: Icons.insert_drive_file_rounded,
            color: AppColors.secondary,
            title: 'Dokumen',
            size: '201 MB',
            onClear: () {},
          ),
          _StorageTile(
            icon: Icons.audiotrack_rounded,
            color: AppColors.tertiary,
            title: 'Pesan Suara',
            size: '98 MB',
            onClear: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_sweep_rounded),
            label: const Text('Bersihkan Semua Cache'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageBar extends StatelessWidget {
  final List<_StorageItem> items;
  const _StorageBar({required this.items});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: items.map((item) => Expanded(
          flex: (item.fraction * 100).toInt(),
          child: Container(height: 12, color: item.color),
        )).toList(),
      ),
    );
  }
}

class _StorageItem {
  final String label;
  final double fraction;
  final Color color;
  const _StorageItem(this.label, this.fraction, this.color);
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String size;
  const _LegendItem(this.label, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label: $size',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 12, color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}

class _StorageTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String size;
  final VoidCallback onClear;

  const _StorageTile({
    required this.icon, required this.color, required this.title,
    required this.size, required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
      ),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Text(size, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: TextButton(
          onPressed: onClear,
          child: const Text('Hapus', style: TextStyle(color: AppColors.error,
              fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
