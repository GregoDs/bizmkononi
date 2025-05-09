import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final password1Controller = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ObscureTextCubit obscureTextCubit = ObscureTextCubit();
  final ObscureTextCubit obscureTextCubit1 = ObscureTextCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());

  final phoneKey = 'resetPhone';
  final codeKey = 'resetCode';
  final passKey = 'resetPass';
  final pass1Key = 'resetPass1';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.clear();
    codeController.clear();
    passwordController.clear();
    password1Controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    formValidationCubit.validateField(phoneKey, false);
    formValidationCubit.validateField(codeKey, false);
    formValidationCubit.validateField(passKey, false);
    formValidationCubit.validateField(pass1Key, false);
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final phone = arguments['phone'];
    phoneController.text = phone;
    formValidationCubit.validateField(phoneKey, true);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listener: (context, state) {
            if (state is AuthLoaded) {
              Navigator.pushReplacementNamed(context, Routes.signIn);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                      left: 23,
                      right: 23,
                      bottom: 23,
                    ),
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
                decoration: const BoxDecoration(
                  color: ColorName.primaryColor,
                ),
                child: SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorName.whiteColor,
                      ),
                    );
                  },
                ),
              );
            }
            return BlocBuilder<FormValidationCubit, Map<String, bool>>(
              bloc: formValidationCubit,
              builder: (context, state) {
                bool isFormValid = formValidationCubit.isFormValid();
                return SingleChildScrollView(
                  child: Container(
                    height: ScreenUtil().screenHeight,
                    width: ScreenUtil().screenWidth,
                    decoration:
                        const BoxDecoration(color: ColorName.primaryColor),
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        AppText.large(
                          'Reset Password',
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
                          readOnly: true,
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
                          height: 20.h,
                        ),
                        AppText.medium(
                          'Code',
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomTextField(
                          controller: codeController,
                          formValidationCubit: formValidationCubit,
                          fieldId: codeKey,
                          keyboardType: TextInputType.number,
                          fillColor: ColorName.textfieldColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        AppText.medium(
                          'Password',
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          formValidationCubit: formValidationCubit,
                          fieldId: passKey,
                          fillColor: ColorName.textfieldColor,
                          isPassword: true,
                          obscureTextCubit: obscureTextCubit,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        AppText.medium(
                          'Confirm Password',
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomTextField(
                          controller: password1Controller,
                          formValidationCubit: formValidationCubit,
                          fieldId: pass1Key,
                          fillColor: ColorName.textfieldColor,
                          isPassword: true,
                          obscureTextCubit: obscureTextCubit1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if (passwordController.text != value) {
                              return 'Passwords Do not match';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              onTap: isFormValid
                                  ? () async {
                                      var data = {
                                        'code': codeController.text,
                                        'phone': phoneController.text,
                                        'password': passwordController.text
                                      };
                                      await authCubit.resetPassword(data);
                                    }
                                  : () {},
                              width: 150.w,
                              text: 'Reset',
                              color: isFormValid
                                  ? ColorName.blue200
                                  : ColorName.buttonDisabled,
                              textColor: isFormValid
                                  ? ColorName.whiteColor
                                  : Colors.grey,
                            ),
                          ],
                        ),
                        const Spacer(),
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
                                      text: 'Already Have an Account? ',
                                    ),
                                    TextSpan(
                                      text: 'Sign In',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                              context,
                                              Routes.signIn,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: ColorName.whiteColor,
                                    fontSize: 12.sp,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Don\'t have an account yet? ',
                                    ),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style:
                                          const TextStyle(color: Colors.blue),
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
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
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
