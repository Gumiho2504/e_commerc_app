import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerc_app/admin/screens/add_item_screen.dart';
import 'package:e_commerc_app/user/screens/product_detail_screen.dart';
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
            'signup': (context) => SignUpScreen(),
            'user_home': (context) => HomeScreen(),
            'admin_home': (context) => Admin.HomeScreen(),
            'add_item': (context) => AddItemScreen(),
            'detail': (context) => ProductDetailScreen(),
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

class AuthHandler extends StatefulWidget {
  const AuthHandler({super.key});

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  User? _currentUser;
  String? _role;
  @override
  void initState() {
    _initializeAuthState();
    super.initState();
  }

  void _initializeAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (!mounted) return;
        if (userDoc.exists) {
          setState(() {
            _role = userDoc['role'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      ///print(_currentUser);

      return LoginScreen();
    }
    if (_role == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //print(_role);
    return _role == 'admin' ? Admin.HomeScreen() : HomeScreen();
  }
}
