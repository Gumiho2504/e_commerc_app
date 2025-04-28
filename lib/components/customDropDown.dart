import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomDropDown extends HookWidget {
  const CustomDropDown(
    this.onChanged, {
    super.key,

    required this.items,
    this.label,
  });
  final String? label;

  final List<String> items;
  final void Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isShowItem = useState(false);
    final selectedValue = useState<int?>(null);
    return Column(
      children: [
        IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 30.h,

            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: ThemeData().primaryColor),
              borderRadius: BorderRadius.circular(2.h),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  selectedValue.value != null
                      ? '${label!} : ${items[selectedValue.value!]}'
                      : label ?? '',
                  style: TextStyle(
                    fontSize: 12.h,
                    color: ThemeData().primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    isShowItem.value = !isShowItem.value;
                  },

                  splashColor: ThemeData().primaryColor.withAlpha(40),
                  child: Icon(
                    !isShowItem.value
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: ThemeData().primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        if (isShowItem.value)
          IntrinsicHeight(
            child: Container(
              //width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5, color: ThemeData().primaryColor),
                borderRadius: BorderRadius.circular(2.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  items.length,
                  (i) => InkWell(
                    onTap: () {
                      onChanged!(selectedValue.value);
                      selectedValue.value = i;
                      isShowItem.value = false;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 2.h,
                      ),
                      child: Text(
                        items[i],
                        style: TextStyle(
                          fontSize: 12.h,
                          color: ThemeData().primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
