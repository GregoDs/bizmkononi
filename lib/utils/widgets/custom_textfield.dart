import '../../exports.dart';
import 'package:pin_code_fields/pin_code_fields.dart' as pin_code;

class ObscureTextCubit extends Cubit<bool> {
  ObscureTextCubit() : super(true);

  void toggle() => emit(!state);
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final AppText? label;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? color;
  final double borderRadius;
  final bool? isLogin;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool isPassword;
  final ObscureTextCubit? obscureTextCubit;
  final FormValidationCubit? formValidationCubit;
  final String? Function(String?)? validator;
  final String fieldId;
  final Color? fillColor;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
    this.color = Colors.black,
    this.suffix,
    this.borderRadius = 12, // Increased for a more rounded look
    this.suffixIcon,
    this.prefixIcon,
    this.isLogin = false,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.isPassword = false,
    this.obscureTextCubit,
    required this.formValidationCubit,
    this.validator,
    this.readOnly = false,
    required this.fieldId,
    this.fillColor = const Color(0xFFF2F2F7), // Light grey background
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPassword) {
      return buildTextField(context, false);
    }
    return BlocBuilder<ObscureTextCubit, bool>(
      bloc: obscureTextCubit!,
      builder: (context, obscureText) {
        return buildTextField(context, obscureText);
      },
    );
  }

  Widget buildTextField(BuildContext context, bool obscureText) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) {
        onChanged?.call(value);
        bool isValid = validator != null ? validator!(value) == null : true;
        formValidationCubit!.validateField(fieldId, isValid);
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.red,
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8E8E93), // Subtle grey for hint text
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: fillColor,
        label: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xFF007AFF)), // Apple blue
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ), // Consistent padding
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF007AFF),
                  size: 20,
                ),
                onPressed: () => obscureTextCubit!.toggle(),
              )
            : suffixIcon,
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16,
        letterSpacing: 0.3,
        fontFamily: 'Poppins',
      ),
    );
  }
}

// verification_text_field.dart

class OtpVerificationField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormValidationCubit formValidationCubit;
  final String fieldId;
  final String? Function(String?)? validator;
  final Color fillColor;

  const OtpVerificationField({
    Key? key,
    required this.controller,
    required this.formValidationCubit,
    required this.fieldId,
    this.onChanged,
    this.validator,
    this.fillColor = Colors.white, // Ensures white fill unless overridden
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return pin_code.PinCodeTextField(
      appContext: context,
      length: 6,
      controller: controller,
      autoDisposeControllers: false,
      animationType: pin_code.AnimationType.fade,
      enableActiveFill: true,
      pinTheme: pin_code.PinTheme(
        shape: pin_code.PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5), // Figma spec
        fieldHeight: 74, // Figma height
        fieldWidth: 56, // Figma width
        borderWidth: 1, // Figma border width
        activeColor: ColorName.primaryColor,
        inactiveColor: Colors.grey.shade400,
        selectedColor: ColorName.primaryColor,
        selectedFillColor: Colors.white, // ⬅️ Explicit white fill
        inactiveFillColor: Colors.white, // ⬅️ Explicit white fill
        activeFillColor: Colors.white, // ⬅️ Explicit white fill
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 20.sp,
        letterSpacing: 0.3,
        fontFamily: 'Poppins',
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        onChanged?.call(value);
        bool isValid = validator != null ? validator!(value) == null : true;
        formValidationCubit.validateField(fieldId, isValid);
      },
      validator: validator,
    );
  }
}

// In app Text fields

class ServicesTextField extends StatelessWidget {
  final TextEditingController controller;
  final AppText? label;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? color;
  final double borderRadius;
  final bool? isLogin;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool isPassword;
  final ObscureTextCubit? obscureTextCubit;
  final FormValidationCubit? formValidationCubit;
  final String? Function(String?)? validator;
  final String fieldId;
  final Color? fillColor;
  final Function(String)? onChanged;

  // Default constructor
  const ServicesTextField({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.color,
    required this.borderRadius,
    this.isLogin,
    this.hintText,
    this.labelText,
    this.keyboardType,
    required this.readOnly,
    required this.isPassword,
    this.obscureTextCubit,
    this.formValidationCubit,
    this.validator,
    required this.fieldId,
    this.fillColor = const Color(0xFFF2F2F7),
    this.onChanged,
  });

  // Named constructor
  const ServicesTextField.custom({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
    this.color = Colors.black,
    this.suffix,
    this.borderRadius = 12, // Increased for a more rounded look
    this.suffixIcon,
    this.prefixIcon,
    this.isLogin = false,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.readOnly = false,
    this.isPassword = false,
    this.obscureTextCubit,
    this.formValidationCubit,
    this.validator,
    required this.fieldId,
    this.fillColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPassword) {
      return buildTextField(context, false);
    }
    return BlocBuilder<ObscureTextCubit, bool>(
      bloc: obscureTextCubit!,
      builder: (context, obscureText) {
        return buildTextField(context, obscureText);
      },
    );
  }

  Widget buildTextField(BuildContext context, bool obscureText) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) {
        onChanged?.call(value);
        bool isValid = validator != null ? validator!(value) == null : true;
        formValidationCubit!.validateField(fieldId, isValid);
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.red,
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8E8E93), // Subtle grey for hint text
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: fillColor,
        label: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color(0xFFF2F2F7)), // Apple blue
          
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ), // Consistent padding
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF007AFF),
                  size: 20,
                ),
                onPressed: () => obscureTextCubit!.toggle(),
              )
            : suffixIcon,
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16,
        letterSpacing: 0.3,
        fontFamily: 'Poppins',
      ),
    );
  }
}

class ServicesDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;
  final String? hintText;
  final String? labelText;
  final Color? fillColor;
  final double borderRadius;
  final bool readOnly;
  final String? Function(T?)? validator;
  final AppText? label;

  const ServicesDropdownField({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.fillColor = const Color(0xFFF2F2F7),
    this.borderRadius = 12,
    this.readOnly = false,
    this.validator,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: readOnly ? null : onChanged,
      validator: validator,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.red,
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8E8E93),
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        filled: true,
        fillColor: fillColor,
        label: label,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        prefixIcon: prefixIcon,
      ),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16,
        letterSpacing: 0.3,
        fontFamily: 'Poppins',
      ),
      dropdownColor: fillColor,
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF007AFF)),
      iconSize: 24,
      isExpanded: true,
    );
  }
}
