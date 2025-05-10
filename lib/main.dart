import 'package:e_commerc_app/admin/screens/add_item_screen.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:e_commerc_app/auth/services/notification_service.dart';
import 'package:e_commerc_app/user/screens/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_commerc_app/user/screens/home_screen.dart';
// ignore: library_prefixes
import 'package:e_commerc_app/admin/screens/home_screen.dart' as Admin;
import 'package:e_commerc_app/auth/login_screen.dart';
import 'package:e_commerc_app/auth/signup_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  // await FirebaseMessaging.instance.getInitialMessage();
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  await FirebaseApi().initNotifications();
  await ScreenUtil.ensureScreenSize();
  //await FirebaseMessaging.instance.getAPNSToken();
  final user = FirebaseAuth.instance.currentUser;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ProviderScope(child: MyApp(isLogin: user != null)));
  });
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
            'cart': (context) => CartScreen(),
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

class AuthHandler extends StatefulHookConsumerWidget {
  const AuthHandler({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends ConsumerState<AuthHandler> {
  @override
  Widget build(BuildContext context) {
    final authStateChange = ref.watch(authStateChangesProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final role = useState<String?>(null);
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      print('New FCM Token: $token');
      // Send token to your server if needed
    });
    if (authStateChange.value == null) {
      return LoginScreen();
    }

    useEffect(() {
      void getRole() async {
        await Future.delayed(Duration(milliseconds: 1000));
        role.value = await authRepository.getUserRole();
      }

      getRole();
      return null;
    });

    if (role.value == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //print(_role);
    return role.value == 'admin' ? Admin.HomeScreen() : HomeScreen();
  }
}
