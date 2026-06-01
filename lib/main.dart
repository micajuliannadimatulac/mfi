import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/index_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_admin_screen.dart';
import 'screens/settings_admin_screen.dart';
import 'screens/settings_admin_edit_screen.dart';
import 'state/blocked_users_state.dart';
import 'styles/app_styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;

  await BlockedUsersState.init(
    defaultBlockedEmails: <String>{
      'jmmcasia3@addu.edu.ph',
    },
  );

  runApp(const MahintanaApp());
}

class MahintanaApp extends StatelessWidget {
  const MahintanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mahintana Foundation, Inc.',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(),
      ),

      initialRoute: '/',

      onGenerateRoute: (settings) {
        Widget screen;

        switch (settings.name) {
          case '/login':
            screen = const LoginScreen();
            break;

          case '/signup':
            screen = const SignupScreen();
            break;

          case '/dashboard-admin':
            screen = const DashboardAdminScreen();
            break;

          case '/settings-admin':
            screen = const SettingsAdminScreen();
            break;

          case '/settings-admin-edit':
            screen = const SettingsAdminEditScreen();
            break;

          case '/':
          default:
            screen = const IndexScreen();
            break;
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}