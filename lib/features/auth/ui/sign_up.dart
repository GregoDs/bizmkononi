import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ObscureTextCubit obscureTextCubit = ObscureTextCubit();
  final ObscureTextCubit obscureTextCubit1 = ObscureTextCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());
  PolicyCubit policyCubit = PolicyCubit();
  bool policy = false;

  final fnameKey = 'signUpfName';
  final lnameKey = 'signUplName';
  final emailKey = 'signUpEmail';
  final phoneKey = 'signUpPhone';
  final pass1Key = 'signUpPass1';
  final pass2Key = 'signUpPass2';

  String formatString(String input) {
    // Trim leading and trailing spaces
    String trimmedInput = input.trim();

    // Capitalize the first letter
    String formattedString =
        trimmedInput.substring(0, 1).toUpperCase() + trimmedInput.substring(1);

    return formattedString;
  }

  @override
  void dispose() {
    super.dispose();
    fnameController.clear();
    lnameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    formValidationCubit.resetState();
    formValidationCubit.validateField(fnameKey, false);
    formValidationCubit.validateField(lnameKey, false);
    formValidationCubit.validateField(emailKey, false);
    formValidationCubit.validateField(phoneKey, false);
    formValidationCubit.validateField(pass1Key, false);
    formValidationCubit.validateField(pass2Key, false);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background vector images
            Positioned(
              bottom: -40,
              left: -120,
              child: Image.asset(
                'assets/images/vectorsplash.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),

            BlocConsumer<AuthCubit, AuthState>(
              bloc: authCubit,
              listener: (context, state) {
                if (state is AuthLoaded) {
                  showSuccess(context,
                      'Sign Up Success,Kindly Verify your Phone number');
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.verify,
                    arguments: {
                      'phone': phoneController.text,
                    },
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
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: 20),
                      behavior: SnackBarBehavior.floating,
                    ));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
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
                    return Container(
                      decoration:
                          const BoxDecoration(color: ColorName.whiteColor),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.04),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),

                              //logo
                              Center(
                                child: Image.asset(
                                  Assets.images.logotext.path,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),

                              // Title
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                  letterSpacing: -0.7,
                                  color: ColorName.primaryColor,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),

                              // First Name and Last Name in a Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.medium(
                                          'First Name',
                                          color: ColorName.primaryColor,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        CustomTextField(
                                          controller: fnameController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          fieldId: fnameKey,
                                          fillColor: ColorName.lightGrey,
                                          validator: Functions()
                                              .noSpecialCharactersValidator,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.medium(
                                          'Last Name',
                                          color: ColorName.primaryColor,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        CustomTextField(
                                          controller: lnameController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          fieldId: lnameKey,
                                          fillColor: ColorName.lightGrey,
                                          validator: Functions()
                                              .noSpecialCharactersValidator,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),

                              AppText.medium(
                                'Email',
                                color: ColorName.primaryColor,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              CustomTextField(
                                controller: emailController,
                                formValidationCubit: formValidationCubit,
                                fieldId: emailKey,
                                fillColor: ColorName.lightGrey,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => Functions()
                                    .noSpecialCharactersValidator(value,
                                        allowedCharacters: '@.'),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              AppText.medium(
                                'Phone',
                                color: ColorName.primaryColor,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              CustomTextField(
                                controller: phoneController,
                                formValidationCubit: formValidationCubit,
                                fieldId: phoneKey,
                                keyboardType: TextInputType.phone,
                                fillColor: ColorName.lightGrey,
                                validator: (value) =>
                                    Functions().combineValidators(value, [
                                  Functions().noSpecialCharactersValidator,
                                  Functions().phoneNumberValidator,
                                ]),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),

                              // Password and Confirm Password in a Row
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.medium(
                                          'Password',
                                          color: ColorName.primaryColor,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        CustomTextField(
                                          controller: passwordController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          fieldId: pass1Key,
                                          fillColor: ColorName.lightGrey,
                                          isPassword: true,
                                          obscureTextCubit: obscureTextCubit,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText.medium(
                                          'Confirm Password',
                                          color: ColorName.primaryColor,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        CustomTextField(
                                          controller: passwordConfirmController,
                                          formValidationCubit:
                                              formValidationCubit,
                                          fieldId: pass2Key,
                                          fillColor: ColorName.lightGrey,
                                          isPassword: true,
                                          obscureTextCubit: obscureTextCubit1,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            if (passwordController.text !=
                                                value) {
                                              return 'Passwords Do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              BlocBuilder<PolicyCubit, bool>(
                                bloc: policyCubit,
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        focusColor: Colors.white,
                                        checkColor: Colors.black,
                                        fillColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                                (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.disabled)) {
                                            return Colors.white;
                                          }
                                          return Colors.white;
                                        }),
                                        value: state,
                                        onChanged: (newValue) {
                                          policyCubit.togglePolicy();
                                        },
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.5,
                                                color: ColorName.primaryColor,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'I have read and agreed to the ',
                                                ),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder: (context) =>
                                                          //           const HtmlPage(
                                                          //             policy: true,
                                                          //           )),
                                                          // );
                                                        },
                                                ),
                                                const TextSpan(text: ' and '),
                                                TextSpan(
                                                  text: 'terms',
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder: (context) =>
                                                          //           const HtmlPage(
                                                          //             policy: false,
                                                          //           )),
                                                          // );
                                                        },
                                                ),
                                                const TextSpan(text: '.'),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),

                              // Register button - now full width
                              BlocBuilder<PolicyCubit, bool>(
                                bloc: policyCubit,
                                builder: (context, state) {
                                  return CustomButton(
                                    onTap: isFormValid && policyCubit.state
                                        ? () async {
                                            var data = {
                                              'name':
                                                  '${formatString(fnameController.text)} ${formatString(lnameController.text)}',
                                              'email': emailController.text,
                                              'phone': phoneController.text,
                                              'password':
                                                  passwordController.text,
                                              "subscriptionType": "free-trial",
                                              "freeTrialStartDate": "string"
                                            };
                                            await authCubit.register(data);
                                          }
                                        : () {},
                                    width: double.infinity,
                                    text: 'Register',
                                    color: isFormValid && policyCubit.state
                                        ? ColorName.primaryColor
                                        : ColorName.buttonDisabled,
                                    textColor: isFormValid && policyCubit.state
                                        ? ColorName.whiteColor
                                        : Colors.grey,
                                  );
                                },
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: ColorName.primaryColor,
                                            fontSize: 16,
                                            letterSpacing: -0.6,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Already have an account? ',
                                            ),
                                            TextSpan(
                                              text: 'Sign In',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w800,
                                                color: ColorName.primaryColor,
                                                letterSpacing: -0.6,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    () => Navigator.pushNamed(
                                                          context,
                                                          Routes.signIn,
                                                        ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: ColorName.primaryColor,
                                            fontSize: 16,
                                            letterSpacing: -0.6,
                                          ),
                                        children: [
                                          const TextSpan(
                                            text: 'Resend Verification SMS? ',
                                          ),
                                          TextSpan(
                                            text: 'Resend',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w800,
                                              color: ColorName.primaryColor,
                                              letterSpacing: -0.6,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  Navigator.pushNamed(
                                                      context,
                                                      Routes
                                                          .resendVerification),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: ColorName.primaryColor,
                                            fontSize: 16,
                                            letterSpacing: -0.6,
                                          ),
                                        children: [
                                          const TextSpan(
                                            text: 'Verify Phone? ',
                                          ),
                                          TextSpan(
                                            text: 'Verify',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w800,
                                              color: ColorName.primaryColor,
                                              letterSpacing: -0.6,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  Navigator.pushNamed(
                                                      context, Routes.verify),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PolicyCubit extends Cubit<bool> {
  PolicyCubit() : super(false); // Initial state: unchecked

  void togglePolicy() => emit(!state);
}
