import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import '../../widgets/veten_button.dart';
import '../../widgets/veten_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with SingleTickerProviderStateMixin {
  String _search = '';
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showAddContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        ),
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.xl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Tambah Kontak Baru',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const VetenTextField(
              label: 'Nama Lengkap',
              hint: 'Masukkan nama kontak',
            ),
            const SizedBox(height: AppSpacing.md),
            const VetenTextField(
              label: 'Nomor Telepon',
              hint: '+62 8xx xxxx xxxx',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.xl),
            VetenButton(
              label: 'Simpan Kontak',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kontak berhasil ditambahkan!',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = DummyData.contacts
        .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── HEADER ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 0,
              ctrl: _ctrl,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row
                        Row(
                          children: [
                            Text(
                              'Kontak',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            _HeaderBtn(
                              icon: Icons.person_add_rounded,
                              onTap: () => _showAddContactForm(context),
                            ),
                            const SizedBox(width: 8),
                            _HeaderBtn(
                              icon: Icons.more_horiz_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v),
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 15, color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Cari kontak...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.6)),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── QUICK ACTIONS ───────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 100,
              ctrl: _ctrl,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    _QuickAction(
                      icon: Icons.person_add_rounded,
                      label: 'Tambah\nKontak',
                      color: const Color(0xFF2563EB),
                      iconBg: const Color(0xFFEFF6FF),
                      onTap: () => _showAddContactForm(context),
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.group_add_rounded,
                      label: 'Grup\nBaru',
                      color: const Color(0xFF059669),
                      iconBg: const Color(0xFFECFDF5),
                      onTap: () => context.push('/select-members'),
                    ),
                    const SizedBox(width: 12),
                    _QuickAction(
                      icon: Icons.person_search_rounded,
                      label: 'Permintaan',
                      color: const Color(0xFFD97706),
                      iconBg: const Color(0xFFFFFBEB),
                      onTap: () => context.push('/friend-requests'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── SECTION LABEL ───────────────────────────────────
          SliverToBoxAdapter(
            child: _FadeSlide(
              delay: 150,
              ctrl: _ctrl,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} Kontak',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                          height: 1,
                          color: AppColors.outlineVariant.withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── CONTACT LIST ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final contact = filtered[i];
                  final isLast = i == filtered.length - 1;
                  return _FadeSlide(
                    delay: 180 + (i * 60),
                    ctrl: _ctrl,
                    child: _ContactCard(
                      contact: contact,
                      isLast: isLast,
                      isFirst: i == 0,
                      onCall: () =>
                          context.push('/voice-call/${contact.id}'),
                      onChat: () {
                        final chat = DummyData.chats.firstWhere(
                          (c) => c.contact.id == contact.id,
                          orElse: () => DummyData.chats.first,
                        );
                        context.push('/chat/${chat.id}');
                      },
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ============================================================
// FADE + SLIDE WRAPPER
// ============================================================
class _FadeSlide extends StatelessWidget {
  final int delay;
  final AnimationController ctrl;
  final Widget child;

  const _FadeSlide({
    required this.delay,
    required this.ctrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (delay / 800).clamp(0.0, 1.0);
    final end = ((delay + 400) / 800).clamp(0.0, 1.0);

    final slide = Tween<Offset>(
      begin: const Offset(0.0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: ctrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: ctrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, child) => FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      ),
      child: child,
    );
  }
}

// ============================================================
// HEADER BUTTON
// ============================================================
class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

// ============================================================
// QUICK ACTION
// ============================================================
class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconBg;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconBg,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 120));
  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.93).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTapDown: (_) => _ctrl.forward(),
          onTapUp: (_) {
            _ctrl.reverse();
            widget.onTap();
          },
          onTapCancel: () => _ctrl.reverse(),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) =>
                Transform.scale(scale: _scale.value, child: child),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

// ============================================================
// CONTACT CARD
// ============================================================
class _ContactCard extends StatefulWidget {
  final dynamic contact;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onCall;
  final VoidCallback onChat;

  const _ContactCard({
    required this.contact,
    required this.isFirst,
    required this.isLast,
    required this.onCall,
    required this.onChat,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 0.97).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(
      top: widget.isFirst ? const Radius.circular(18) : Radius.zero,
      bottom: widget.isLast ? const Radius.circular(18) : Radius.zero,
    );

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) => _ctrl.reverse(),
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            boxShadow: widget.isFirst
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                : null,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Avatar
                    VetenAvatar(
                      name: widget.contact.name,
                      imageUrl: widget.contact.avatarUrl,
                      size: AppSpacing.avatarMd,
                      showOnline: true,
                      isOnline: widget.contact.isOnline,
                      isGroup: widget.contact.isGroup,
                    ),
                    const SizedBox(width: 12),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contact.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.contact.bio,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    _ActionBtn(
                      icon: Icons.call_rounded,
                      color: const Color(0xFF2563EB),
                      bg: const Color(0xFFEFF6FF),
                      onTap: widget.onCall,
                    ),
                    const SizedBox(width: 8),
                    _ActionBtn(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: const Color(0xFF059669),
                      bg: const Color(0xFFECFDF5),
                      onTap: widget.onChat,
                    ),
                  ],
                ),
              ),

              // Divider (kecuali item terakhir)
              if (!widget.isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 76),
                  child: Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.outlineVariant.withOpacity(0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ACTION BUTTON
// ============================================================
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 17),
        ),
      );
}
