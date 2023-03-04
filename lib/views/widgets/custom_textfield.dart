import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  // final TextEditingController? controller;
  // final bool? required;
  // final int? maxLines;

  const CustomTextField(
      {Key? key,
      this.hintText,
      // this.controller,
      // this.required = false,
      // this.maxLines
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(hintText!,
        // controller: controller,
        // keyboardType: TextInputType.multiline,
        // maxLines: maxLines,
        // autofocus: true,

        // validator: required == false
        //     ? null
        //     : (value) {
        //         if (value == null || value.isEmpty) {
        //           return 'Please enter some text';
        //         }
        //         return null;
        //       },
        // decoration: InputDecoration(
        //     hintText: hintText ?? "Enter your input here ...",
        //     border: const OutlineInputBorder(),
        //     isDense: true,
        //     label: Text(hintText ?? "")),
      ),
    );
  }
}


class InputTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? tController;
  final Color? hintTextColor;
  final Color? contentTextColor;
  final Color? textFeildColor;
  final double? width;
  final bool? isEnabled;
  final Function? validator;
  InputTextFormField({
    Key? key,
    required this.hintText,
    this.tController,
    this.hintTextColor,
    this.contentTextColor,
    this.textFeildColor,
    this.width,
    this.isEnabled,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Get.size;
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: textFeildColor ?? Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: validator as String? Function(String?)?,
        textCapitalization: TextCapitalization.sentences,
        controller: tController,
        enabled: isEnabled,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ).copyWith(
            color: contentTextColor ?? Color(0xff3a4750), fontSize: 16),
        cursorHeight: 18,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ).copyWith(
            color: contentTextColor ?? Color(0xff3a4750), fontSize: 16),
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
