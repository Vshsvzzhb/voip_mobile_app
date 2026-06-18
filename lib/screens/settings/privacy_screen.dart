import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class _SettingsSwitch extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<_SettingsSwitch> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _val,
      onChanged: (v) {
        setState(() => _val = v);
        widget.onChanged(v);
      },
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      activeColor: AppColors.primary,
    );
  }
}

Widget _sectionHeader(String text) => Padding(
  padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
  child: Text(
    text.toUpperCase(),
    style: GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurfaceVariant,
      letterSpacing: 1.0,
    ),
  ),
);

// ─────────── PRIVACY SCREEN ───────────
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pengaturan Privasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _sectionHeader('Profil'),
          _SettingsSwitch(title: 'Tampilkan foto profil kepada semua', value: true, onChanged: (_) {}),
          _SettingsSwitch(title: 'Tampilkan status online', subtitle: 'Orang lain dapat melihat apakah kamu online', value: true, onChanged: (_) {}),
          _SettingsSwitch(title: 'Tampilkan waktu terakhir aktif', value: false, onChanged: (_) {}),
          const Divider(height: AppSpacing.md),
          _sectionHeader('Pesan'),
          _SettingsSwitch(title: 'Tanda terima dibaca', subtitle: 'Kirim konfirmasi pesan terbaca', value: true, onChanged: (_) {}),
          _SettingsSwitch(title: 'Pesan sementara', subtitle: 'Hapus pesan setelah 24 jam', value: false, onChanged: (_) {}),
          _SettingsSwitch(title: 'Pratinjau pesan di notifikasi', value: true, onChanged: (_) {}),
          const Divider(height: AppSpacing.md),
          _sectionHeader('Panggilan'),
          _SettingsSwitch(title: 'Relai panggilan untuk privasi IP', subtitle: 'Sembunyikan alamat IP saat panggilan', value: false, onChanged: (_) {}),
          ListTile(
            title: const Text('Pengguna Diblokir'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/blocked-users'),
          ),
        ],
      ),
    );
  }
}
