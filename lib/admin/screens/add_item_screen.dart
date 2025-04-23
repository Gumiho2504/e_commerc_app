import 'dart:io';

import 'package:e_commerc_app/admin/controllers/add_item_controller.dart';
import 'package:e_commerc_app/admin/model/item.dart';
import 'package:e_commerc_app/components/text_input.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddItemPageState();
}

class _AddItemPageState extends ConsumerState<AddItemScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Padding(
        padding: EdgeInsets.all(20.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.h,
              children: [
                GestureDetector(
                  onTap: () {
                    print("pick image ${state.image != null}");
                    notifier.pickImage();
                  },
                  child: Container(
                    height: 160.h,
                    width: 160.h,
                    decoration: BoxDecoration(
                      color: ThemeData().primaryColor,
                      borderRadius: BorderRadius.circular(10.h),
                      image: DecorationImage(
                        image:
                            state.image == null
                                ? AssetImage(
                                  'assets/images/icons/pick_image_icon.png',
                                )
                                : FileImage(File(state.image!)),
                        fit:
                            state.image == null ? BoxFit.contain : BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.black.withAlpha(50)),
                    ),
                  ),
                ),
                InputComponent(
                  label: "Name*",
                  formKey: _formKey,
                  controller: _nameController,
                  textType: TextInputType.name,
                  errorMessage: "Name is required",
                ),
                InputComponent(
                  label: "Price*",
                  formKey: _formKey,
                  controller: _priceController,
                  textType: TextInputType.number,
                  errorMessage: "Price is required",
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
                    label: Text('Category'),
                    hintText: 'Select a category',
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
                  items:
                      state.categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                  // value: productItem.seletedCategory,
                  onChanged: notifier.selectCategory,
                  onSaved: (value) => notifier.selectCategory(value),
                ),
                InputComponent(
                  label: "Size*",
                  formKey: _formKey,
                  controller: _sizeController,
                  textType: TextInputType.name,
                  errorMessage: "Size is required",
                  onSubmitted: (value) {
                    notifier.addSize(value);
                    _sizeController.clear();
                  },
                ),
                Wrap(
                  spacing: 10.w,
                  children:
                      state.sizes
                          .map(
                            (size) => Chip(
                              label: Text(size),
                              onDeleted: () => notifier.removeSzie(size),
                            ),
                          )
                          .toList(),
                ),
                InputComponent(
                  label: "Color*",
                  formKey: _formKey,
                  controller: _colorController,
                  textType: TextInputType.name,
                  errorMessage: "Color is required",
                  onSubmitted: (value) {
                    notifier.addColor(value);
                    _colorController.clear();
                  },
                ),
                Wrap(
                  spacing: 10.w,
                  children:
                      state.colors
                          .map(
                            (color) => Chip(
                              label: Text(color),
                              onDeleted: () => notifier.removeColor(color),
                            ),
                          )
                          .toList(),
                ),

                Row(
                  children: [
                    Checkbox(
                      checkColor: ThemeData().secondaryHeaderColor,
                      focusColor: ThemeData().primaryColor,
                      activeColor: ThemeData().primaryColor,
                      value: state.isDiscount,
                      onChanged: notifier.toggleDiscount,
                    ),
                    Text(
                      "Apply Discount",
                      style: TextStyle(
                        color: ThemeData().primaryColor,

                        fontSize: 16.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                state.isDiscount!
                    ? InputComponent(
                      label: "Discount(%)",
                      formKey: _formKey,
                      controller: _discountController,
                      textType: TextInputType.number,
                      errorMessage: "Name is required",
                      onSubmitted: notifier.setDiscountPercentage,
                    )
                    : SizedBox(height: 1),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              notifier.AddItem(
                                _nameController.text,
                                _priceController.text,
                              );

                              if (!state.isLoading) Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        child:
                            state.isLoading
                                ? CircularProgressIndicator()
                                : Text("Add Item"),
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

  _categoriesDropDown(List<String> items, Item productItem) =>
      DropdownButtonFormField(
        alignment: AlignmentDirectional.bottomStart,
        style: TextStyle(
          color: ThemeData().primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: ThemeData().primaryColor.withAlpha(200)),
          label: Text('Role'),
          hintText: 'Select a category',
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
        items: List.generate(items.length, (index) {
          return DropdownMenuItem(
            value: index,
            child: Text(items[index].toUpperCase()),
          );
        }),
        validator: (value) {
          if (value == null) {
            return 'Please select a role';
          }
          return null;
        },
        value: productItem.seletedCategory,
        onChanged: (value) {
          //productItem
        },
      );
}
