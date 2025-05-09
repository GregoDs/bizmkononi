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

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.onTap,
    this.color = ColorName.blackColor,
    this.suffix,
    this.borderRadius = 8,
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
    this.fillColor = Colors.white,
    
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
        bool isValid = validator != null ? validator!(value) == null : true;
        formValidationCubit!.validateField(fieldId, isValid);
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Colors.red,
          fontFamily: 'Poppins', // Poppins for error text
          fontSize: 12.sp,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorName.mainGrey,
          fontSize: 16.sp, // Increased from 14.sp
          fontFamily: 'Poppins', // Poppins for hint
        ),
        filled: true,
        fillColor: fillColor,
        label: label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.fromLTRB(9.w, 6.h, 9.w, 6.h), // Increased padding
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColorName.primaryColor,
                  size: 22, // Slightly larger icon
                ),
                onPressed: () => obscureTextCubit!.toggle(),
              )
            : suffixIcon,
      ),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: color,
        fontSize: 16.sp, // Increased from 16.sp
        letterSpacing: 0.3,
        fontFamily: 'Poppins', // Poppins for input text
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
        fieldWidth: 56,  // Figma width
        borderWidth: 1,  // Figma border width
        activeColor: ColorName.primaryColor,
        inactiveColor: Colors.grey.shade400,
        selectedColor: ColorName.primaryColor,
        selectedFillColor: Colors.white, // ⬅️ Explicit white fill
        inactiveFillColor: Colors.white, // ⬅️ Explicit white fill
        activeFillColor: Colors.white,   // ⬅️ Explicit white fill
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