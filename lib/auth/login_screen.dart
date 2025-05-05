import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerc_app/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerc_app/components/text_input.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final authService = ref.watch(authRepositoryProvider);
    final result = useState<String?>(null);
    // ignore: deprecated_member_use
    final isMounted = useIsMounted();
    void signin() async {
      final respone = await authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (!isMounted()) return;
      result.value = respone;
      if (result.value == 'admin') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login successful $result')));
        Navigator.pushNamed(context, 'admin_home');
      } else if (result.value == 'user') {
        Navigator.pushNamed(context, 'user_home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(' $result')));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10.h,
              children: [
                Text(
                  'Gumiho Store',
                  style: TextStyle(
                    fontSize: 70.h,
                    fontWeight: FontWeight.bold,
                    color: ThemeData().primaryColor,
                    height: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'login',
                  style: TextStyle(
                    fontSize: 40.h,
                    fontWeight: FontWeight.bold,
                    color: ThemeData().primaryColor,
                  ),
                ),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 12.h,
                    fontWeight: FontWeight.w500,
                    color: ThemeData().primaryColor.withAlpha(200),
                  ),
                ),

                Form(
                  key: formKey,
                  child: Column(
                    spacing: 10.h,
                    children: [
                      InputComponent(
                        formKey: formKey,
                        controller: emailController,
                        textType: TextInputType.emailAddress,
                        label: 'Email',
                        errorMessage: 'Enter a valid email',
                      ),
                      InputComponent(
                        formKey: formKey,
                        controller: passwordController,
                        textType: TextInputType.visiblePassword,
                        label: 'Password',
                        errorMessage: 'Password is required',
                      ),

                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.h),
                          backgroundColor: ThemeData().primaryColor,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            signin();
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                        color: ThemeData().primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //print('click');
                        Navigator.pushReplacementNamed(context, 'signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.deepOrange,
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
