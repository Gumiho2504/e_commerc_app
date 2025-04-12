import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:e_commerc_app/screens/home_screen.dart';
import 'package:e_commerc_app/screens/login_screen.dart';
import 'package:e_commerc_app/screens/signup_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtil.ensureScreenSize();
  final user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(isLogin: user != null));
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
            'home': (context) => HomeScreen(),
          },
          theme: ThemeData(
            primaryColor: Colors.deepPurple,
            secondaryHeaderColor: Colors.deepPurpleAccent.withAlpha(200),
            textTheme: TextTheme(),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: GoogleFonts.poppins().fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: isLogin ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
