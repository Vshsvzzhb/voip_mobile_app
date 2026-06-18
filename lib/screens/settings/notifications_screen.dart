import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _sectionHeader(String text) => Padding(
  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
  child: Text(
    text.toUpperCase(),
    style: GoogleFonts.plusJakartaSans(
      fontSize: 11, fontWeight: FontWeight.w700,
      color: AppColors.onSurfaceVariant, letterSpacing: 1.0,
    ),
  ),
);

class _SwitchTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool value;
  const _SwitchTile({required this.title, this.subtitle, required this.value});
  @override State<_SwitchTile> createState() => _SwitchTileState();
}
class _SwitchTileState extends State<_SwitchTile> {
  late bool _val;
  @override void initState() { super.initState(); _val = widget.value; }
  @override
  Widget build(BuildContext context) => SwitchListTile(
    value: _val, onChanged: (v) => setState(() => _val = v),
    title: Text(widget.title),
    subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
    activeColor: AppColors.primary,
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _sectionHeader('Pesan'),
          const _SwitchTile(title: 'Notifikasi pesan', value: true),
          const _SwitchTile(title: 'Suara notifikasi pesan', value: true),
          const _SwitchTile(title: 'Getar pada pesan baru', value: false),
          const Divider(height: AppSpacing.md),
          _sectionHeader('Grup'),
          const _SwitchTile(title: 'Notifikasi grup', value: true),
          const _SwitchTile(title: 'Tampilkan preview pesan grup', value: true),
          const Divider(height: AppSpacing.md),
          _sectionHeader('Panggilan'),
          const _SwitchTile(title: 'Notifikasi panggilan masuk', value: true),
          const _SwitchTile(title: 'Nada dering', subtitle: 'Nada dering default', value: true),
          const Divider(height: AppSpacing.md),
          _sectionHeader('Lainnya'),
          const _SwitchTile(title: 'Notifikasi do not disturb', subtitle: 'Batasi notifikasi saat tidak ingin diganggu', value: false),
          ListTile(
            title: const Text('Jadwal tidak ingin diganggu'),
            subtitle: const Text('Nonaktif'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
