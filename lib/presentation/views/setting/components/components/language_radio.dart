import 'package:flutter/material.dart';

class LanguageRadio extends StatelessWidget {
  const LanguageRadio({
    Key? key,required this.value,required this.groupValue,required this.onChanged,
  }) : super(key: key);

  final dynamic value;
  final dynamic groupValue;
  final Function(dynamic val)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
