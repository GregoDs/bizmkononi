import 'package:biz_mkononi/features/auth/ui/verify.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../../../exports.dart';

class ResendVerification extends StatefulWidget {
  const ResendVerification({super.key});

  @override
  State<ResendVerification> createState() => _ResendVerificationState();
}

class _ResendVerificationState extends State<ResendVerification> {
  final phoneController = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());
  final phoneKey = 'verificationCodePhone';

  @override
  void dispose() {
    super.dispose();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    formValidationCubit.resetState();
    formValidationCubit.validateField(phoneKey, false);
    
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listener: (context, state) {
            if (state is AuthLoaded) {
              showSuccess(context, 'Code resend Success');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => Verify(
                        phoneNumber: phoneController.text,
                      )),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(left: 23, right: 23, bottom: 23),
                  behavior: SnackBarBehavior.floating,
                ));
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
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80.h),
                      
                      // Title
                      const Center(
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            letterSpacing: -0.7,
                            color: ColorName.primaryColor,
                          ),
                        ),
                      ),
                      
                      // Lottie animation
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
                          'You need to verify with your Mobile Number\nto secure your business today',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      // Phone number input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            // Country code
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '+254',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            
                            // Phone number field
                            Expanded(
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter phone number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  bool isValid = value.isNotEmpty;
                                  formValidationCubit.validateField(phoneKey, isValid);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      // Resend button
                      Center(
                        child: CustomButton(
                          onTap: isFormValid
                              ? () async {
                                  var data = {
                                    'phone': phoneController.text,
                                  };
                                  await authCubit.resendCode(data);
                                }
                              : null,
                          width: double.infinity,
                          height: 40.h,
                          text: 'Get OTP',
                          color: isFormValid
                              ? ColorName.primaryColor
                              : ColorName.buttonDisabled,
                          textColor: ColorName.whiteColor,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      // Bottom navigation links
                      Center(
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: ColorName.primaryColor,
                                  fontSize: 16,
                                ),
                                children: [
                                  const TextSpan(text: 'Back to Login? '),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                            context,
                                            Routes.signIn,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: ColorName.primaryColor,
                                  fontSize: 16,
                                ),
                                children: [
                                  const TextSpan(text: 'Create Account? '),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                            context,
                                            Routes.signUp,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}