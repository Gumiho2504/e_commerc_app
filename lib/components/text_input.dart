import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputComponent extends StatefulWidget {
  const InputComponent({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController controller,
    required TextInputType textType,
    this.label,
    this.errorMessage,
    this.onSubmitted,
  }) : _formKey = formKey,
       _controller = controller,
       _type = textType;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _controller;
  final TextInputType _type;
  final String? label;
  final String? errorMessage;
  final void Function(String)? onSubmitted;

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  bool isView = false;
  @override
  Widget build(BuildContext context) {
    bool isObscure = widget._type == TextInputType.visiblePassword;

    return TextFormField(
      style: TextStyle(
        color: ThemeData().primaryColor,
        fontWeight: FontWeight.w700,
      ),
      obscureText: isObscure && isView,
      obscuringCharacter: "*",
      focusNode: FocusNode(),
      keyboardType: widget._type,

      validator: (value) {
        if (widget.label!.toLowerCase() == "discount") {
          return null;
        } else {
          if (value == null || value.isEmpty) {
            return widget.errorMessage; // e.g. "Password is required"
          }

          if (isObscure && value.length < 8) {
            return "Password must be at least 8 characters"; // 👈 match number in message
          }
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

      controller: widget._controller,
      onFieldSubmitted: (value) => widget.onSubmitted!(value),
      decoration: InputDecoration(
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              isView = !isView;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Icon(
              isView ? Icons.visibility : Icons.visibility_off,
              color: ThemeData().primaryColor.withAlpha(200),
              size: isObscure ? 20.h : 0,
            ),
          ),
        ),
        labelStyle: TextStyle(color: ThemeData().primaryColor.withAlpha(200)),
        label: Text(widget.label ?? ""),
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
