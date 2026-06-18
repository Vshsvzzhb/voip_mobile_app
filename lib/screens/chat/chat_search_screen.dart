import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final _searchCtrl = TextEditingController(text: 'vaksin');
  String _selectedFilter = 'Semua';

  final List<String> _filters = ['Semua', 'Media', 'Dokumen', 'Link'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Area
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant, size: 18),
                            onPressed: () => _searchCtrl.clear(),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filters
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filter,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Hasil Chat Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'HASIL CHAT',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant.withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.sm),
            
            // Results
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                children: [
                  _SearchResultCard(
                    name: 'Dr. Anisa Hermawan',
                    time: '12 Okt, 14:20',
                    text: 'Halo, apakah jadwal vaksin rabies untuk si Muezza sudah bisa dikonfirmasi untuk besok...',
                    query: 'vaksin',
                  ),
                  _SearchResultCard(
                    name: 'VetenCall Support',
                    time: 'Kemarin',
                    text: 'Berikut adalah artikel panduan mengenai jenis-jenis vaksin kucing yang wajib Anda ketahui.',
                    query: 'vaksin',
                    mediaWidget: _buildMediaAttachment(),
                  ),
                  _SearchResultCard(
                    name: 'Pak Budi (Pemilik Anabul)',
                    time: '08 Okt, 09:15',
                    text: 'Saya baru saja mengunggah sertifikat vaksin yang lama di dokumen profil. Mohon diperiksa y...',
                    query: 'vaksin',
                    documentName: 'Sertifikat_Vaksin.pdf',
                  ),
                  _SearchResultCard(
                    name: 'Anda',
                    time: '05 Okt',
                    text: 'Baik pak, untuk biaya vaksin F3 dan F4 sudah saya rincikan di invoice sebelumnya.',
                    query: 'vaksin',
                  ),
                  const SizedBox(height: AppSpacing.xl * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaAttachment() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&q=80&w=400',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panduan Lengkap Vaksinasi Kucing 2024',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'vetencall.com/blog/vaksin-kucing',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final String name;
  final String time;
  final String text;
  final String query;
  final Widget? mediaWidget;
  final String? documentName;

  const _SearchResultCard({
    required this.name,
    required this.time,
    required this.text,
    required this.query,
    this.mediaWidget,
    this.documentName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _HighlightedText(text: text, query: query),
          if (mediaWidget != null) mediaWidget!,
          if (documentName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    documentName!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceVariant),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    
    final int index = lowerText.indexOf(lowerQuery);
    if (index == -1) {
      return Text(
        text,
        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceVariant),
      );
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: AppColors.onSurfaceVariant,
          height: 1.4,
        ),
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              backgroundColor: Colors.yellow.withOpacity(0.5),
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}
