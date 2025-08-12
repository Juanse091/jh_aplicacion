import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String>? validator;
  final bool isOptional;
  final String? initialValue;
  final bool readOnly;
  final TextEditingController? controller;  // <-- agregado

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.onSaved,
    this.validator,
    this.isOptional = false,
    this.initialValue,
    this.readOnly = false,
    this.controller,   // <-- recibido en constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,  // <-- aquí
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        onSaved: (val) => isOptional
            ? onSaved(val?.isNotEmpty == true ? val : null)
            : onSaved(val ?? ''),
        validator: isOptional
            ? null
            : validator ?? (val) => val!.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }
}
