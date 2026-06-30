import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/home/chat_list_screen.dart';
import '../../screens/chat/chat_room_screen.dart';
import '../../screens/chat/chat_search_screen.dart';
import '../../screens/call/incoming_call_screen.dart';
import '../../screens/call/voice_call_screen.dart';
import '../../screens/call/video_call_screen.dart';
import '../../screens/call/group_voice_call_screen.dart';
import '../../screens/call/group_video_call_screen.dart';
import '../../screens/call/call_log_screen.dart';
import '../../screens/contacts/contacts_screen.dart';
import '../../screens/contacts/select_members_screen.dart';
import '../../screens/contacts/group_info_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/settings/privacy_screen.dart';
import '../../screens/settings/notifications_screen.dart';
import '../../screens/settings/tts_settings_screen.dart';
import '../../screens/settings/security_screen.dart';
import '../../screens/settings/app_lock_screen.dart';
import '../../screens/settings/storage_screen.dart';
import '../../screens/settings/blocked_users_screen.dart';
import '../../screens/settings/friend_requests_screen.dart';
import '../../screens/main_shell.dart';

// ============================================================
// UNIVERSAL TRANSITION — ringan, smooth, berlaku semua halaman
// ============================================================

/// Transisi universal: fade ringan + slide micro dari bawah.
/// Sangat ringan, tidak berat di GPU, terasa native.
Page<void> _page({required LocalKey key, required Widget child}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Halaman baru: naik sedikit dari bawah + fade in
      final enter = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final slideIn = Tween<Offset>(
        begin: const Offset(0.0, 0.04),  // Micro-slide: hanya 4% tinggi layar
        end: Offset.zero,
      ).animate(enter);
      final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
      );

      // Halaman lama: sedikit scale down + fade (efek depth)
      final leave = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);
      final scaleOut = Tween<double>(begin: 1.0, end: 0.97).animate(leave);
      final fadeOut = Tween<double>(begin: 1.0, end: 0.88).animate(leave);

      return FadeTransition(
        opacity: fadeOut,
        child: ScaleTransition(
          scale: scaleOut,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(
              opacity: fadeIn,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

/// Transisi horizontal — khusus untuk auth (Login ↔ Register)
Page<void> _sidePage({
  required LocalKey key,
  required Widget child,
  bool fromRight = true,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: Offset(fromRight ? 0.2 : -0.2, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: fade, child: child),
      );
    },
  );
}

// ============================================================
// ROUTER
// ============================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [

    // ─── SPLASH & ONBOARDING ───────────────────────────────
    GoRoute(
      path: '/splash',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const SplashScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const OnboardingScreen()),
    ),

    // ─── AUTH ──────────────────────────────────────────────
    GoRoute(
      path: '/login',
      pageBuilder: (c, s) => _sidePage(key: s.pageKey, child: const LoginScreen(), fromRight: false),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (c, s) => _sidePage(key: s.pageKey, child: const RegisterScreen(), fromRight: true),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (c, s) => _page(
        key: s.pageKey,
        child: OtpScreen(phone: s.uri.queryParameters['phone'] ?? ''),
      ),
    ),

    // ─── MAIN SHELL (Bottom nav tabs) ──────────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',     builder: (c, s) => const ChatListScreen()),
        GoRoute(path: '/calls',    builder: (c, s) => const CallLogScreen()),
        GoRoute(path: '/contacts', builder: (c, s) => const ContactsScreen()),
        GoRoute(path: '/profile',  builder: (c, s) => const ProfileScreen()),
      ],
    ),

    // ─── CHAT ──────────────────────────────────────────────
    GoRoute(
      path: '/chat/:contactId',
      pageBuilder: (c, s) => _page(
        key: s.pageKey,
        child: ChatRoomScreen(contactId: s.pathParameters['contactId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/chat-search',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const ChatSearchScreen()),
    ),

    // ─── CALLS ─────────────────────────────────────────────
    GoRoute(
      path: '/incoming-call',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const IncomingCallScreen()),
    ),
    GoRoute(
      path: '/voice-call/:contactId',
      pageBuilder: (c, s) => _page(
        key: s.pageKey,
        child: VoiceCallScreen(contactId: s.pathParameters['contactId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/video-call/:contactId',
      pageBuilder: (c, s) => _page(
        key: s.pageKey,
        child: VideoCallScreen(contactId: s.pathParameters['contactId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/group-voice-call',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const GroupVoiceCallScreen()),
    ),
    GoRoute(
      path: '/group-video-call',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const GroupVideoCallScreen()),
    ),

    // ─── CONTACTS ──────────────────────────────────────────
    GoRoute(
      path: '/select-members',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const SelectMembersScreen()),
    ),
    GoRoute(
      path: '/group-info',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const GroupInfoScreen()),
    ),

    // ─── PROFILE & SETTINGS ────────────────────────────────
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const EditProfileScreen()),
    ),
    GoRoute(
      path: '/privacy',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const PrivacyScreen()),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const NotificationsScreen()),
    ),
    GoRoute(
      path: '/tts-settings',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const TtsSettingsScreen()),
    ),
    GoRoute(
      path: '/security',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const SecurityScreen()),
    ),
    GoRoute(
      path: '/app-lock',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const AppLockScreen()),
    ),
    GoRoute(
      path: '/storage',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const StorageScreen()),
    ),
    GoRoute(
      path: '/blocked-users',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const BlockedUsersScreen()),
    ),
    GoRoute(
      path: '/friend-requests',
      pageBuilder: (c, s) => _page(key: s.pageKey, child: const FriendRequestsScreen()),
    ),
  ],
);
