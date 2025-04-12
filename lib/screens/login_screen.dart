import 'package:e_commerc_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerc_app/components/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();
  void signin() async {
    String? result = await authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (result == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login successful $result')));
      Navigator.pushNamed(context, 'home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(' $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  key: _formKey,
                  child: Column(
                    spacing: 10.h,
                    children: [
                      InputComponent(
                        formKey: _formKey,
                        controller: _emailController,
                        textType: TextInputType.emailAddress,
                        label: 'Email',
                        errorMessage: 'Enter a valid email',
                      ),
                      InputComponent(
                        formKey: _formKey,
                        controller: _passwordController,
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
                          if (_formKey.currentState!.validate()) {
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
                        print('click');
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
