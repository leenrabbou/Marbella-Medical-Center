import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeTextField extends StatelessWidget {
  const CodeTextField({
    super.key,
    required this.textController,
    required this.isLast,
  });
  final TextEditingController textController;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 54,
      child: TextFormField(
        controller: textController,
        onChanged: (value) {
          if (!isLast && value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          hintText: '0',
          fillColor: Theme.of(context).colorScheme.surface,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          errorStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color.fromARGB(45, 3, 3, 3)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color.fromARGB(45, 3, 3, 3)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
