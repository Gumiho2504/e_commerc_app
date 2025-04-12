import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputComponent extends StatelessWidget {
  const InputComponent({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required TextInputType textType,
    this.label,
    this.errorMessage,
  }) : _formKey = formKey,
       _controller = controller,
       _type = textType;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _controller;
  final TextInputType _type;
  final String? label;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    bool isObscure = _type == TextInputType.visiblePassword;
    return TextFormField(
      style: TextStyle(
        color: ThemeData().primaryColor,
        fontWeight: FontWeight.w700,
      ),
      obscureText: isObscure,
      obscuringCharacter: "*",
      focusNode: FocusNode(),
      keyboardType: _type,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage; // e.g. "Password is required"
        }

        if (isObscure && value.length < 8) {
          return "Password must be at least 8 characters"; // 👈 match number in message
        }

        return null;
      },

      onChanged: (value) {},
      onTap: () {
        // if (_formKey.currentState != null) {
        //   _formKey.currentState!.validate();
        // }
      },
      onTapOutside: (event) {
        //FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: _controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: ThemeData().primaryColor.withAlpha(200)),
        label: Text(label ?? ""),
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
    );
  }
}
