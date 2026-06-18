import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class TtsSettingsScreen extends StatefulWidget {
  const TtsSettingsScreen({super.key});

  @override
  State<TtsSettingsScreen> createState() => _TtsSettingsScreenState();
}

class _TtsSettingsScreenState extends State<TtsSettingsScreen> {
  double _speed = 1.0;
  double _pitch = 1.0;
  bool _autoRead = false;
  String _language = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pengaturan Text-to-Speech'),
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
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.record_voice_over_rounded,
                      color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Text-to-Speech Aktif',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      Text('Pesan akan dibacakan secara otomatis',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 12, color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCard(
            children: [
              ListTile(
                title: const Text('Bahasa'),
                subtitle: Text(_language),
                trailing: DropdownButton<String>(
                  value: _language,
                  underline: const SizedBox(),
                  items: ['Bahasa Indonesia', 'English', 'Jawa', 'Sunda']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _language = v!),
                ),
              ),
              const Divider(height: 0),
              SwitchListTile(
                title: const Text('Baca Otomatis'),
                subtitle: const Text('Bacakan pesan saat tiba'),
                value: _autoRead,
                onChanged: (v) => setState(() => _autoRead = v),
                activeColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCard(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                child: Text('Kecepatan Bicara',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              Slider(
                value: _speed,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                label: '${_speed.toStringAsFixed(1)}x',
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _speed = v),
              ),
              const Divider(height: 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                child: Text('Nada Bicara (Pitch)',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              Slider(
                value: _pitch,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                label: '${_pitch.toStringAsFixed(1)}x',
                activeColor: AppColors.secondary,
                onChanged: (v) => setState(() => _pitch = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Uji Suara TTS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.outlineVariant, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}
