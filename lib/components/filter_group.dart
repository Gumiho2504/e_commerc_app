
import 'package:e_commerc_app/components/customDropDown.dart';
import 'package:flutter/material.dart';


class FilterGroup extends StatelessWidget {
  const FilterGroup({
    super.key,
    required this.filters,
    required this.currenctSelect,
    required this.selectedFilters,
    required this.currenentCategory,
  });

  final List<Map<String, dynamic>> filters;
  final ValueNotifier<int> currenctSelect;
  final ValueNotifier<Map<String, dynamic>> selectedFilters;
  final ValueNotifier<String?> currenentCategory;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              filters.map((filter) {
                final key = filter.keys.first;
                final values = filter.values.first;
                return CustomDropDown(
                  currentSelect: key == 'category' ? currenctSelect.value : 0,
                  (value) {
                    // print("select - ${key} : ${value}");
                    selectedFilters.value = {
                      ...selectedFilters.value,
                      key: value,
                    };
                    if (key == 'category') {
                      currenentCategory.value = value;
                      selectedFilters.value['category'] = value;
                      print('sel1 0- ${selectedFilters.value['categoru']}');
                    }
                  },

                  items: values,
                  label: key,
                );
              }).toList(),
        ),
      ),
    );
  }
}

