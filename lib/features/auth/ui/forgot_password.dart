import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final phoneController = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());
  final phoneKey = 'forgotPasswordPhone';

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
        body: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listener: (context, state) {
            if (state is AuthLoaded) {
              showSuccess(context, 'Code sent Successfully');
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.resetPassword,
                  arguments: {
                    'phone': phoneController.text,
                  },
                );
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.only(left: 23, right: 23, bottom: 23),
                  behavior: SnackBarBehavior.floating,
                ));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Container(
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                decoration: const BoxDecoration(color: ColorName.primaryColor),
                child: Center(
                  child: SpinKitWave(
                    itemBuilder: (BuildContext context, int index) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          color: ColorName.whiteColor,
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            // else if (state is AuthError) {
            //   return Center(child: AppText.medium(state.message));
            // }
            return BlocBuilder<FormValidationCubit, Map<String, bool>>(
              bloc: formValidationCubit,
              builder: (context, state) {
                bool isFormValid = formValidationCubit.isFormValid();
                return Container(
                  height: ScreenUtil().screenHeight,
                  width: ScreenUtil().screenWidth,
                  decoration:
                      const BoxDecoration(color: ColorName.primaryColor),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      AppText.large(
                        'Forgot Password',
                        color: ColorName.whiteColor,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      AppText.medium(
                        'Phone',
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      CustomTextField(
                        controller: phoneController,
                        formValidationCubit: formValidationCubit,
                        fieldId: phoneKey,
                        keyboardType: TextInputType.phone,
                        fillColor: ColorName.textfieldColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Center(
                        child: CustomButton(
                          onTap: isFormValid
                              ? () async {
                                  var data = {
                                    'phone': phoneController.text,
                                  };
                                  await authCubit.forgotPassword(data);
                                }
                              : () {},
                          width: 300.w,
                          text: 'Submit',
                          color: isFormValid
                              ? ColorName.blue200
                              : ColorName.buttonDisabled,
                          textColor:
                              isFormValid ? ColorName.whiteColor : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: ColorName.whiteColor,
                                    fontSize: 12.sp,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Back to Login? ',
                                    ),
                                    TextSpan(
                                      text: 'Sign In',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                              context,
                                              Routes.signIn,
                                            ),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: ColorName.whiteColor,
                                  fontSize: 12.sp,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Create Account? ',
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: const TextStyle(color: Colors.blue),
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
