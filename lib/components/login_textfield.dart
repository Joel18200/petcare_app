import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawfect/utils/constants.dart';
import 'package:pawfect/utils/extensions.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    required this.labelText,
    required this.textInputType,
    required this.focusNode,
    required this.nextFocusNode,
    required this.isLast,
    required this.onChanged,
    this.icon, // Made optional
    this.defaultIcon, // Added default icon option
    required this.obscureText,
    super.key,
  });

  final String labelText;
  final String? icon; // Optional SVG icon
  final IconData? defaultIcon; // Optional Flutter icon
  final TextInputType textInputType;
  final FocusNode? focusNode, nextFocusNode;
  final bool isLast, obscureText;
  final ValueSetter<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grayTwoColor,
      ),
      child: Row(
        children: [
          if (icon != null)
            SvgPicture.asset(icon!)
          else if (defaultIcon != null)
            Icon(defaultIcon, color: Theme.of(context).hintColor, size: 24), // Default Flutter Icon
          const SizedBox(width: 10),
          Flexible(
            child: TextField(
              onChanged: onChanged,
              focusNode: focusNode,
              textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
              onSubmitted: (value) {
                if (!isLast) {
                  FocusScope.of(context).requestFocus(nextFocusNode);
                } else {
                  context.hideKeyboard();
                }
              },
              keyboardType: textInputType,
              style: GoogleFonts.fredoka(
                fontSize: 20,
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(4),
                isDense: true,
                hintText: labelText,
                hintStyle: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              obscureText: obscureText,
              enableSuggestions: !obscureText,
              autocorrect: !obscureText,
            ),
          ),
        ],
      ),
    );
  }
}
