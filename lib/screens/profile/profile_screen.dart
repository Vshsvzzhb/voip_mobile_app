import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../widgets/veten_avatar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _contentCtrl;

  late Animation<double> _avatarScale;
  late Animation<double> _avatarOpacity;
  late Animation<double> _nameSlide;
  late Animation<double> _nameOpacity;
  late Animation<double> _badgeSlide;
  late Animation<double> _badgeOpacity;
  late Animation<double> _contentSlide;
  late Animation<double> _contentOpacity;

  @override
  void initState() {
    super.initState();

    // Header animation (avatar, name, badge)
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Content animation (cards)
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Avatar: scale 0.5 → 1.0
    _avatarScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _avatarOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    // Name: slide up
    _nameSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );

    // Badge: fade + slide
    _badgeSlide = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.5, 0.9, curve: Curves.easeOut)),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: const Interval(0.5, 0.9, curve: Curves.easeOut)),
    );

    // Content cards: slide up
    _contentSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic),
    );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut),
    );

    // Start header first, then content
    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(
        children: [
          // ─── GRADIENT BG ──────────────────────────────────
          Container(
            height: 320,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0038C0), Color(0xFF1A56DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ─── SCROLLABLE BODY ──────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // TOP BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Profil Saya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        _HeaderBtn(icon: Icons.edit_rounded, onTap: () => context.push('/edit-profile')),
                        const SizedBox(width: 8),
                        _HeaderBtn(icon: Icons.more_horiz_rounded, onTap: () {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── AVATAR (animated) ──────────────────────
                  AnimatedBuilder(
                    animation: _headerCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _avatarOpacity.value,
                      child: Transform.scale(
                        scale: _avatarScale.value,
                        child: child,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 106,
                          height: 106,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.35), width: 3),
                          ),
                        ),
                        VetenAvatar(name: user.name, imageUrl: user.avatarUrl, size: 94),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryContainer,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── NAME (animated slide) ──────────────────
                  AnimatedBuilder(
                    animation: _headerCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _nameOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _nameSlide.value),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          user.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_rounded, size: 12, color: Colors.white.withOpacity(0.65)),
                            const SizedBox(width: 4),
                            Text(
                              user.phone,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─── BADGE (animated) ───────────────────────
                  AnimatedBuilder(
                    animation: _headerCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _badgeOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _badgeSlide.value),
                        child: child,
                      ),
                    ),
                    child: _OnlineBadge(),
                  ),

                  const SizedBox(height: 32),

                  // ─── CONTENT CARDS (animated) ───────────────
                  AnimatedBuilder(
                    animation: _contentCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _contentOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _contentSlide.value),
                        child: child,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // BIO
                          _BioCard(bio: user.bio),
                          const SizedBox(height: 24),

                          // AKUN
                          _Label('Akun'),
                          const SizedBox(height: 10),
                          _StaggerCard(
                            delay: 0,
                            contentCtrl: _contentCtrl,
                            child: _Card(children: [
                              _SlideIn(delay: 600, child: _Tile(icon: Icons.shield_outlined, label: 'Keamanan Akun', sub: 'Password & autentikasi', color: const Color(0xFF2563EB), onTap: () => context.push('/security'))),
                              _Divider(),
                              _SlideIn(delay: 680, child: _Tile(icon: Icons.remove_red_eye_outlined, label: 'Privasi', sub: 'Kelola visibilitas akun', color: const Color(0xFF059669), onTap: () => context.push('/privacy'))),
                              _Divider(),
                              _SlideIn(delay: 760, child: _Tile(icon: Icons.notifications_none_rounded, label: 'Notifikasi', sub: 'Suara & getaran', color: const Color(0xFFD97706), onTap: () => context.push('/notifications'), isLast: true)),
                            ]),
                          ),

                          const SizedBox(height: 24),

                          // PREFERENSI
                          _Label('Preferensi'),
                          const SizedBox(height: 10),
                          _StaggerCard(
                            delay: 100,
                            contentCtrl: _contentCtrl,
                            child: _Card(children: [
                              _SlideIn(delay: 700, child: _Tile(icon: Icons.spatial_audio_off_rounded, label: 'Pengaturan TTS', sub: 'Text-to-speech', color: const Color(0xFF7C3AED), onTap: () => context.push('/tts-settings'))),
                              _Divider(),
                              _SlideIn(delay: 780, child: _Tile(icon: Icons.folder_copy_outlined, label: 'Penyimpanan', sub: 'Cache & media lokal', color: const Color(0xFF0891B2), onTap: () => context.push('/storage'))),
                              _Divider(),
                              _SlideIn(delay: 860, child: _Tile(icon: Icons.fingerprint_rounded, label: 'Kunci Aplikasi', sub: 'Biometrik & PIN', color: const Color(0xFFDB2777), onTap: () => context.push('/app-lock'), isLast: true)),
                            ]),
                          ),

                          const SizedBox(height: 24),

                          // SOSIAL
                          _Label('Sosial'),
                          const SizedBox(height: 10),
                          _StaggerCard(
                            delay: 200,
                            contentCtrl: _contentCtrl,
                            child: _Card(children: [
                              _SlideIn(delay: 800, child: _Tile(icon: Icons.group_add_outlined, label: 'Permintaan Pertemanan', sub: 'Terima & kelola kontak', color: const Color(0xFF2563EB), onTap: () => context.push('/friend-requests'))),
                              _Divider(),
                              _SlideIn(delay: 880, child: _Tile(icon: Icons.block_rounded, label: 'Pengguna Diblokir', sub: 'Daftar kontak diblokir', color: const Color(0xFFDC2626), onTap: () => context.push('/blocked-users'), isLast: true)),
                            ]),
                          ),

                          const SizedBox(height: 24),

                          // LOGOUT
                          _StaggerCard(
                            delay: 300,
                            contentCtrl: _contentCtrl,
                            child: _LogoutButton(onTap: () => context.go('/login')),
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'VetenCall · v1.0.0',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// STAGGER CARD WRAPPER
// ==========================================================
class _StaggerCard extends StatefulWidget {
  final int delay;
  final AnimationController contentCtrl;
  final Widget child;

  const _StaggerCard({
    required this.delay,
    required this.contentCtrl,
    required this.child,
  });

  @override
  State<_StaggerCard> createState() => _StaggerCardState();
}

class _StaggerCardState extends State<_StaggerCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: 500 + widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: child,
          ),
        ),
        child: widget.child,
      );
}

// ==========================================================
// HELPERS
// ==========================================================

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

class _OnlineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('Online', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
          ],
        ),
      );
}

class _BioCard extends StatefulWidget {
  final String bio;
  const _BioCard({required this.bio});

  @override
  State<_BioCard> createState() => _BioCardState();
}

class _BioCardState extends State<_BioCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slide;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _slide = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(_slide.value, 0),
            child: child,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF818CF8)]),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bio', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant, letterSpacing: 0.4)),
                    const SizedBox(height: 3),
                    Text(widget.bio, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF1E293B), height: 1.4)),
                  ],
                ),
              ),
              Icon(Icons.edit_note_rounded, color: AppColors.onSurfaceVariant.withOpacity(0.35), size: 22),
            ],
          ),
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B))),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: AppColors.outlineVariant.withOpacity(0.4))),
        ],
      );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(children: children),
        ),
      );
}

// ── SLIDE-IN WRAPPER (entry animation, slide from right) ──
class _SlideIn extends StatefulWidget {
  final int delay;
  final Widget child;
  const _SlideIn({required this.delay, required this.child});

  @override
  State<_SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<_SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _x = Tween<double>(begin: 40.0, end: 0.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  late final Animation<double> _op = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Opacity(
          opacity: _op.value,
          child: Transform.translate(offset: Offset(_x.value, 0), child: child),
        ),
        child: widget.child,
      );
}

// ── TILE ─────────────────────────────────────────────────
class _Tile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;
  final bool isLast;

  const _Tile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.97)
      .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) { _pressCtrl.reverse(); widget.onTap(); },
        onTapCancel: () => _pressCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _pressCtrl,
          builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(13)),
                  child: Icon(widget.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                      const SizedBox(height: 1),
                      Text(widget.sub, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant.withOpacity(0.5), size: 18),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 72),
        child: Divider(height: 1, thickness: 0.5, color: AppColors.outlineVariant.withOpacity(0.5)),
      );
}

class _LogoutButton extends StatefulWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (ctx, child) => Transform.scale(scale: _scale.value, child: child),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                const SizedBox(width: 10),
                Text('Keluar dari Akun',
                    style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFFDC2626))),
              ],
            ),
          ),
        ),
      );
}
