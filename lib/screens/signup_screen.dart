import 'package:e_commerc_app/models/user.dart';
import 'package:e_commerc_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerc_app/components/text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int?  _selectValue = 0;
  final _roles = [Role.user, Role.admin];

  AuthService authService = AuthService();

  void signup() async {
    String? result = await authService.signUp(
      _userName.text,
      _emailController.text,
      _passwordController.text,
      _roles[_selectValue!],
    );

    if (result == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('account created successfully')));
      Navigator.pushNamed(context, 'login');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$result')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  'sign up'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40.h,
                    fontWeight: FontWeight.bold,
                    color: ThemeData().primaryColor,
                  ),
                ),
                Text(
                  'Create an account ${_roles[_selectValue!]}',
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
                        controller: _userName,
                        textType: TextInputType.emailAddress,
                        label: 'Username',
                        errorMessage: 'Username is required',
                      ),
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

                      DropdownButtonFormField(

                        alignment: AlignmentDirectional.bottomStart,
                        style: TextStyle(
                          color: ThemeData().primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: ThemeData().primaryColor.withAlpha(200),
                          ),
                          label: Text('Role'),
                          hintText: 'Select a role',
                          hintStyle: TextStyle(
                            color: ThemeData().primaryColor.withAlpha(200),
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: ThemeData().primaryColor.withAlpha(200),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 10.w,
                              color: ThemeData().primaryColor.withAlpha(200),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        items: List.generate(_roles.length, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(_roles[index].name.toUpperCase()),
                          );
                        }),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                        value: _selectValue,
                        onChanged: (value) {
                          setState(() {
                            _selectValue = value;
                          });
                        },
                      ),
                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.h),
                          backgroundColor: ThemeData().primaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signup();
                          }
                        },
                        child: Text(
                          'Sign Up',
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
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                        color: ThemeData().primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: Text(
                        'Sign In',
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
