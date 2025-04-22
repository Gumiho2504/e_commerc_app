import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputComponent extends HookWidget {
  const InputComponent({
    super.key,
    required this.formKey,
    required this.controller,
    required this.textType,
    this.label,
    this.errorMessage,
    this.onSubmitted,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final TextInputType textType;
  final String? label;
  final String? errorMessage;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final isView = useState(false);
    final isObscure = textType == TextInputType.visiblePassword;

    return TextFormField(
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w700,
      ),
      obscureText: isObscure && !isView.value,
      obscuringCharacter: "*",
      keyboardType: textType,
      controller: controller,

      validator: (value) {
        if (label!.contains("Size") || label!.contains("Color")) return null;

        if (value == null || value.isEmpty) {
          return errorMessage;
        }

        if (isObscure && value.length < 8) {
          return "Password must be at least 8 characters";
        }

        return null;
      },

      onFieldSubmitted: onSubmitted,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),

      decoration: InputDecoration(
        suffixIcon:
            isObscure
                ? IconButton(
                  icon: Icon(
                    isView.value ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    size: 20.h,
                  ),
                  onPressed: () => isView.value = !isView.value,
                )
                : null,
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor.withAlpha(200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor.withAlpha(200),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }
}
