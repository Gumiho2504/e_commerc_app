import 'package:e_commerc_app/user/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends HookConsumerWidget {
  SearchField({super.key, required this.onchange});
  final void Function(String) onchange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final controller = useTextEditingController();
    return SizedBox(
      height: 50.h,

      child: TextFormField(
        controller: controller,
        autofocus: false,
        onTapOutside: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onchange,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),

          hintText: "Search ",
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColor.withAlpha(200),
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(45.r),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withAlpha(200),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.r)),
        ),
      ),
    );
  }
}
