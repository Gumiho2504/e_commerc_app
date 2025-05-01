import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/admin/screens/add_item_screen.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_commerc_app/user/screens/home_screen.dart';
import 'package:e_commerc_app/admin/screens/home_screen.dart' as Admin;
import 'package:e_commerc_app/auth/login_screen.dart';
import 'package:e_commerc_app/auth/signup_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  final user = FirebaseAuth.instance.currentUser;

  runApp(ProviderScope(child: MyApp(isLogin: user != null)));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 930),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, chilc) {
        return MaterialApp(
          title: 'E-Commerc App',
          initialRoute: '/',
          routes: {
            'login': (context) => LoginScreen(),
            'signup': (context) => SignupScreen(),
            'user_home': (context) => HomeScreen(),
            'admin_home': (context) => Admin.HomeScreen(),
            'add_item': (context) => AddItemScreen(),
            //  'detail': (context) => ProductDetailScreen(),
          },
          theme: ThemeData(
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.deepPurple,
              textTheme: ButtonTextTheme.primary,
            ),
            primaryColor: Colors.deepPurple,
            secondaryHeaderColor: Colors.deepPurpleAccent.withAlpha(200),
            textTheme: TextTheme(),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: AuthHandler(),
        );
      },
    );
  }
}

class AuthHandler extends ConsumerStatefulWidget {
  const AuthHandler({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends ConsumerState<AuthHandler> {
  @override
  Widget build(BuildContext context) {
    final authStateChange = ref.watch(authStateChangesProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    String? role;

    if (authStateChange.value == null) {
      return LoginScreen();
    }

    if (authRepository.getUserRole() == "") {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //print(_role);
    return authRepository.getUserRole() == 'admin'
        ? Admin.HomeScreen()
        : HomeScreen();
  }
}
