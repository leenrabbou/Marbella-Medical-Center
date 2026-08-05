import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:marbella/generated/l10n.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String text;
  final TextInputType? type;
  final bool isPassword;
  final bool isPhone;
  final IconData? icon;
  final TextEditingController? controller;
  final int? minLength;
  final double? width, height, left, right, top, bottom;
  final bool? multiLine;
  final String? errorMsg;
  final Color? fillColor;
  final Icon? prefix;
  final bool? hasSuffixToggle;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final bool isValidation;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.text,
    this.type,
    this.isPassword = false,
    this.icon,
    this.controller,
    this.minLength,
    this.width,
    this.height,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.multiLine = false,
    this.errorMsg,
    this.fillColor,
    this.prefix,
    this.hasSuffixToggle = false,
    this.inputFormatter,
    this.maxLength,
    required this.isPhone,
    required this.isValidation,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.left!,
        right: widget.right!,
        top: widget.top!,
        bottom: widget.bottom!,
      ),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.text, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 5.h),
            TextFormField(
              maxLines: widget.multiLine! ? 3 : 1,
              controller: widget.controller,
              validator: widget.isValidation
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return widget.errorMsg ?? S().field_is_required;
                      } else if (widget.isPassword && value.length < 6) {
                        return S().password_too_short;
                      } else if (widget.isPhone &&
                          (value.length < 10 ||
                              !value.trim().startsWith("09"))) {
                        return S().invalid_phone_number;
                      }
                      return null;
                    }
                  : null,
              inputFormatters: widget.isPhone
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              maxLength: widget.maxLength,
              keyboardType: widget.type,
              obscureText: widget.isPassword && _obscure,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                ),
                counterText: '',
                filled: true,
                fillColor: widget.fillColor ?? colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  borderSide: BorderSide(
                    color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  borderSide: BorderSide(
                    color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                suffixIcon: widget.isPassword || widget.hasSuffixToggle == true
                    ? IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(170),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      )
                    : null,
                prefixIcon:
                    widget.prefix ??
                    (widget.icon != null
                        ? Icon(
                            widget.icon,
                            color: colorScheme.primary,
                            size: 22,
                          )
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
