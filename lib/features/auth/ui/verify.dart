import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../exports.dart';

class Verify extends StatefulWidget {
  const Verify({
    super.key,
    required this.phoneNumber,
  });
  final String phoneNumber;

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final codeController = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());
  final codeKey = 'verifyCode';

  @override
  void initState() {
    super.initState();
    formValidationCubit.validateField(codeKey, false);
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white, // Changed to white background
        body: SingleChildScrollView(
          child: BlocConsumer<AuthCubit, AuthState>(
            bloc: authCubit,
            listener: (context, state) {
              if (state is AuthLoaded) {
                showSuccess(context, 'Verification Success, You Can Sign In');
                Navigator.pushReplacementNamed(context, Routes.signIn);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('Oops! An Error occurred'),
                      duration: const Duration(seconds: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                          left: 23, right: 23, bottom: 23),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return Container(
                  height: ScreenUtil().screenHeight,
                  width: ScreenUtil().screenWidth,
                  color: Colors.white,
                  child: Center(
                    child: SpinKitWave(
                      itemBuilder: (BuildContext context, int index) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            color: ColorName.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

              return BlocBuilder<FormValidationCubit, Map<String, bool>>(
                bloc: formValidationCubit,
                builder: (context, state) {
                  bool isFormValid = formValidationCubit.isFormValid();
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 80.h),
                                                // Title
                        const Center(
                          child: Text(
                              'Verify Account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 30, // Slightly larger
                                letterSpacing: -0.7, // Reduced spacing
                                color: ColorName.primaryColor,
                              ),
                            ),
                            
                        ),

                        // Lottie animation for OTP verification
                        Center(
                          child: Lottie.asset(
                            'assets/images/otpver.json',
                            width: 240.w,
                            height: 160.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Instruction text
                        const Center(
                          child: Text(
                              'Enter your Verification Code',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 24, // Slightly larger
                                letterSpacing: -0.9, // Reduced spacing
                                color: ColorName.primaryColor,
                              ),
                            ),
                        ),
                        SizedBox(height: 9.h),
                        // Phone number text
                        Center(
                          child: Text(
                               'We sent a verification code to \n ${widget.phoneNumber}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 16, // Slightly larger
                                letterSpacing: -0.7, // Reduced spacing
                                color:  Colors.grey[600],
                              ),
                            ),
                        ),
                        SizedBox(height: 30.h),
                        // OTP input field
                        OtpVerificationField(
                          controller: codeController,
                          formValidationCubit: formValidationCubit,
                          fieldId: codeKey,
                          fillColor: Colors.grey[100]!,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the verification code';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            formValidationCubit.validateField(
                                codeKey, value.isNotEmpty);
                          },
                        ),
                        SizedBox(height: 30.h),
                        // Verify button
                        Center(
                          child: CustomButton(
                            onTap: isFormValid
                                ? () async {
                                    var data = {
                                      'code': codeController.text,
                                      'phone': widget.phoneNumber,
                                    };
                                    await authCubit.verifyCode(data);
                                  }
                                : null,
                            width: double.infinity,
                            height: 40.h,
                            text: 'Verify OTP',
                            color: isFormValid
                                ? ColorName.primaryColor
                                : ColorName.buttonDisabled,
                            textColor: isFormValid
                                ? ColorName.whiteColor
                                : ColorName.whiteColor,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Resend code text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: ColorName.primaryColor,
                                        letterSpacing: -0.6,
                                        fontSize: 18,
                                      ),
                              children: [
                                const TextSpan(text: "Didn't receive code? "),
                                TextSpan(
                                  text: 'Resend again',
                                  style: const TextStyle(
                                    color: ColorName.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, Routes.resendVerification),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}