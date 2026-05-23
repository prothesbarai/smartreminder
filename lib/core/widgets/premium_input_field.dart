import 'package:flutter/material.dart';

enum FieldType { text, email, password, number, multiline, search, }

class PremiumInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FieldType type;
  final bool enabled;
  final bool readOnly;
  final String? hint;
  final String? helperText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLength;
  const PremiumInputField({super.key, required this.controller, required this.label, required this.icon, this.type = FieldType.text, this.enabled = true, this.readOnly = false, this.hint, this.helperText, this.validator, this.onChanged, this.suffix, this.prefix, this.maxLength,});

  @override
  State<PremiumInputField> createState() => _PremiumInputFieldState();
}

class _PremiumInputFieldState extends State<PremiumInputField> {
  bool obscure = true;
  bool isFocused = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {setState(() {isFocused = focusNode.hasFocus;});});
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool get isPassword => widget.type == FieldType.password;

  TextInputType get keyboardType {
    switch (widget.type) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  int get maxLines => widget.type == FieldType.multiline ? 5 : 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: isFocused ? 18 : 8, offset: const Offset(0, 6),),],),

      child: TextFormField(
        focusNode: focusNode,
        controller: widget.controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        maxLines: maxLines,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        validator: widget.validator,
        style: const TextStyle(color: Color(0xFF202124), fontSize: 15, fontWeight: FontWeight.w500,),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          prefixIcon: widget.prefix ?? Icon(widget.icon, size: 20, color: isFocused ? const Color(0xFF1A73E8) : const Color(0xFF5F6368),),
          suffixIcon: widget.suffix ?? (isPassword ?
          IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: const Color(0xFF5F6368),), onPressed: () {setState(() {obscure = !obscure;});},) :
          widget.type == FieldType.search ? const Icon(Icons.search, size: 20, color: Color(0xFF5F6368)) : null),
          labelText: widget.label,
          hintText: widget.hint,
          labelStyle: TextStyle(color: isFocused ? const Color(0xFF1A73E8) : const Color(0xFF5F6368), fontWeight: FontWeight.w500,),
          hintStyle: const TextStyle(color: Color(0xFF9AA0A6), fontSize: 14,),
          helperText: widget.helperText,
          helperStyle: const TextStyle(color: Color(0xFF9AA0A6), fontSize: 12,),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE0E0E0)),),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE0E0E0)),),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.6,),),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red),),
        ),
      ),
    );
  }
}