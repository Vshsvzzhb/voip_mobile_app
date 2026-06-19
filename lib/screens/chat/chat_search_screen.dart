import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class _MockMsg {
  final String name;
  final String time;
  final String text;
  final bool hasMedia;
  final bool hasDocument;
  final bool hasLink;
  final String? documentName;
  final String? mediaUrl;

  _MockMsg({
    required this.name,
    required this.time,
    required this.text,
    this.hasMedia = false,
    this.hasDocument = false,
    this.hasLink = false,
    this.documentName,
    this.mediaUrl,
  });
}

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  final _searchCtrl = TextEditingController(text: 'vaksin');
  String _query = 'vaksin';
  String _selectedFilter = 'Semua';

  final List<String> _filters = ['Semua', 'Media', 'Dokumen', 'Link'];

  // Data dummy yang bisa difilter untuk mensimulasikan database asli
  final List<_MockMsg> _database = [
    _MockMsg(
      name: 'Dr. Anisa Hermawan',
      time: '12 Okt, 14:20',
      text: 'Halo, apakah jadwal vaksin rabies untuk si Muezza sudah bisa dikonfirmasi untuk besok?',
    ),
    _MockMsg(
      name: 'VetenCall Support',
      time: 'Kemarin',
      text: 'Berikut adalah artikel panduan mengenai jenis-jenis vaksin kucing yang wajib Anda ketahui.',
      hasMedia: true,
      hasLink: true,
      mediaUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&q=80&w=400',
    ),
    _MockMsg(
      name: 'Pak Budi (Pemilik Anabul)',
      time: '08 Okt, 09:15',
      text: 'Saya baru saja mengunggah sertifikat vaksin yang lama di dokumen profil. Mohon diperiksa ya.',
      hasDocument: true,
      documentName: 'Sertifikat_Vaksin.pdf',
    ),
    _MockMsg(
      name: 'Anda',
      time: '05 Okt',
      text: 'Baik pak, untuk biaya vaksin F3 dan F4 sudah saya rincikan di invoice sebelumnya.',
    ),
    _MockMsg(
      name: 'Klinik Hewan Sehat',
      time: '10 Okt',
      text: 'Pemberian obat cacing dan vitamin anjing Anda sudah selesai ya bu. Jangan lupa kontrol.',
    ),
    _MockMsg(
      name: 'Drh. Bima',
      time: '01 Okt',
      text: 'Ini hasil rontgen kaki anjingnya. Ada sedikit masalah di persendian belakang.',
      hasMedia: true,
      mediaUrl: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&q=80&w=400',
    ),
    _MockMsg(
      name: 'Sari (Groomer)',
      time: '02 Okt',
      text: 'Halo kak, untuk jadwal grooming bulan ini saya lampirkan daftar harganya ya.',
      hasDocument: true,
      documentName: 'Pricelist_Grooming_2024.pdf',
    ),
    _MockMsg(
      name: 'VetenCall Blog',
      time: '29 Sep',
      text: 'Promo spesial layanan dokter hewan minggu ini, cek link berikut untuk klaim diskon!',
      hasLink: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Logika Filtering
    final filtered = _database.where((msg) {
      // Filter teks (search query)
      final matchesQuery = _query.isEmpty ||
          msg.name.toLowerCase().contains(_query.toLowerCase()) ||
          msg.text.toLowerCase().contains(_query.toLowerCase());

      if (!matchesQuery) return false;

      // Filter kategori tombol
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Media') return msg.hasMedia;
      if (_selectedFilter == 'Dokumen') return msg.hasDocument;
      if (_selectedFilter == 'Link') return msg.hasLink;

      return false;
    }).toList();

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
                        onChanged: (v) => setState(() => _query = v),
                        style: GoogleFonts.plusJakartaSans(fontSize: 15, color: AppColors.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Cari...',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
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
            
            // Results Area
            Expanded(
              child: Builder(
                builder: (context) {
                  // Filter Kontak (hanya tampil jika filter "Semua" atau query tidak kosong)
                  final filteredContacts = _selectedFilter == 'Semua' && _query.isNotEmpty
                      ? DummyData.contacts
                          .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
                          .toList()
                      : [];

                  if (filtered.isEmpty && filteredContacts.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada hasil yang cocok.',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    children: [
                      // Bagian Kontak
                      if (filteredContacts.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            'KONTAK',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ...filteredContacts.map((c) => ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              leading: VetenAvatar(
                                name: c.name,
                                imageUrl: c.avatarUrl,
                                size: AppSpacing.avatarMd,
                                isOnline: c.isOnline,
                                showOnline: true,
                              ),
                              title: _HighlightedText(text: c.name, query: _query),
                              subtitle: Text(
                                c.bio,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                final chat = DummyData.chats.firstWhere(
                                  (chatObj) => chatObj.contact.id == c.id,
                                  orElse: () => DummyData.chats.first,
                                );
                                context.push('/chat/${chat.id}');
                              },
                            )),
                        const Divider(height: 32, color: AppColors.outlineVariant),
                      ],

                      // Bagian Pesan/Chat
                      if (filtered.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 12),
                          child: Text(
                            'PESAN',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ...filtered.map((msg) => _SearchResultCard(
                              name: msg.name,
                              time: msg.time,
                              text: msg.text,
                              query: _query,
                              documentName: msg.hasDocument ? msg.documentName : null,
                              mediaWidget: msg.hasMedia || msg.hasLink
                                  ? _buildMediaAttachment(msg)
                                  : null,
                            )),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaAttachment(_MockMsg msg) {
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
          if (msg.hasMedia && msg.mediaUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: const Radius.circular(12), bottom: msg.hasLink ? Radius.zero : const Radius.circular(12)),
              child: Image.network(
                msg.mediaUrl!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
          if (msg.hasLink)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tautan Terlampir',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'https://vetencall.com/link',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
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
