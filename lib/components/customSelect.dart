import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSelect<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T? value;
  final String Function(T) getLabel;
  final String? Function(T?)? validator;
  final String isNullAllowText;
  final void Function(T?)? onChanged;

  CustomSelect({
    Key? key,
    this.hintText = 'Please select an Option',
    this.options = const [],
    required this.getLabel,
    required this.value,
    this.validator,
    this.isNullAllowText = "",
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: isNullAllowText.isEmpty ? options.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            getLabel(value),
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black26,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList() : [
        ...options.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              getLabel(value),
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.black26,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }).toList(),
        DropdownMenuItem<T>(
          value: null,
          child: Text(
            isNullAllowText,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black26,
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
      onChanged: onChanged,
      value: value,
      validator: validator,
      isDense: true,
      elevation: 0,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[350],
        hintText: hintText,
        hintStyle: GoogleFonts.lato(
          color: Colors.black26,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconEnabledColor: Colors.black26,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      dropdownColor: Colors.grey[200],
      isExpanded: true,
    );
  }
}
