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

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(
              begin: const Offset(-0.3, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic))),
            child: FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(
              begin: const Offset(0.3, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic))),
            child: FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
              child: child,
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => OtpScreen(
        phone: state.uri.queryParameters['phone'] ?? '',
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
          path: '/calls',
          builder: (context, state) => const CallLogScreen(),
        ),
        GoRoute(
          path: '/contacts',
          builder: (context, state) => const ContactsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/chat/:contactId',
      builder: (context, state) => ChatRoomScreen(
        contactId: state.pathParameters['contactId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/chat-search',
      builder: (context, state) => const ChatSearchScreen(),
    ),
    GoRoute(
      path: '/incoming-call',
      builder: (context, state) => const IncomingCallScreen(),
    ),
    GoRoute(
      path: '/voice-call/:contactId',
      builder: (context, state) => VoiceCallScreen(
        contactId: state.pathParameters['contactId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/video-call/:contactId',
      builder: (context, state) => VideoCallScreen(
        contactId: state.pathParameters['contactId'] ?? '',
      ),
    ),
    GoRoute(
      path: '/group-voice-call',
      builder: (context, state) => const GroupVoiceCallScreen(),
    ),
    GoRoute(
      path: '/group-video-call',
      builder: (context, state) => const GroupVideoCallScreen(),
    ),
    GoRoute(
      path: '/select-members',
      builder: (context, state) => const SelectMembersScreen(),
    ),
    GoRoute(
      path: '/group-info',
      builder: (context, state) => const GroupInfoScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/tts-settings',
      builder: (context, state) => const TtsSettingsScreen(),
    ),
    GoRoute(
      path: '/security',
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: '/app-lock',
      builder: (context, state) => const AppLockScreen(),
    ),
    GoRoute(
      path: '/storage',
      builder: (context, state) => const StorageScreen(),
    ),
    GoRoute(
      path: '/blocked-users',
      builder: (context, state) => const BlockedUsersScreen(),
    ),
    GoRoute(
      path: '/friend-requests',
      builder: (context, state) => const FriendRequestsScreen(),
    ),
  ],
);
