import 'package:biz_mkononi/features/support/loading.dart';
import 'package:biz_mkononi/utils/functions/functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// Import the new Loading widget
import '../../../exports.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ObscureTextCubit obscureTextCubit = ObscureTextCubit();
  final AuthCubit authCubit = AuthCubit(AuthRepo());
  bool remember = false;
  bool _isNavigating = false; // Flag to track navigation state

  final phoneKey = 'signInPhone';
  final passKey = 'signInPass';

  Future<void> getBooleanValue() async {
    formValidationCubit.resetState();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberPrefs = prefs.getBool('remember');
    if (rememberPrefs != null && rememberPrefs == true) {
      String? phone = prefs.getString('phone');
      if (phone != null) {
        phoneController.text = phone;
        passwordController.text = prefs.getString('password') ?? '';
        formValidationCubit.validateField(phoneKey, true);
        formValidationCubit.validateField(passKey, true);
        remember = true;
        setState(() {});
      }
    } else {
      formValidationCubit.validateField(phoneKey, false);
      formValidationCubit.validateField(passKey, false);
    }
  }

  @override
  void initState() {
    super.initState();
    getBooleanValue();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorName.whiteColor,
        body: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [
              /// Top Left Decoration
              Positioned(
                top: -10,
                right: -70,
                child: Image.asset(
                  'assets/images/vectorsplash.png',
                  width: screenWidth * 0.6, // Responsive width
                  fit: BoxFit.cover,
                ),
              ),

              /// Bottom Decoration
              Positioned(
                bottom: -40,
                left: -120,
                child: Image.asset(
                  'assets/images/vectorsplash.png',
                  width: screenWidth * 0.7, // Responsive width
                ),
              ),

              BlocConsumer<AuthCubit, AuthState>(
                bloc: authCubit,
                listener: (context, state) {
                  if (state is AuthError) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else if (state is AuthLoaded && !_isNavigating) {
                    // Prevent multiple navigations
                    _isNavigating = true;

                    // Navigate to the home page after a delay
                    Future.delayed(const Duration(seconds: 60), () {
                      showSuccess(context, 'Sign In Success, Welcome');
                      Navigator.pushReplacementNamed(
                          context, Routes.landingScreen);
                    });
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading || _isNavigating) {
                    // Show the loading page while navigating
                    return LoadingPage(
                      color: ColorName.primaryColor,
                      onLoadingComplete: () {}, // Not used
                    );
                  }

                  // Default UI for other states
                  return BlocBuilder<FormValidationCubit, Map<String, bool>>(
                    bloc: formValidationCubit,
                    builder: (context, state) {
                      bool isFormValid = formValidationCubit.isFormValid();
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08),

                                  // Logo
                                  Center(
                                    child: Image.asset(
                                      Assets.images.logotext.path,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),

                                  const Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 28,
                                        letterSpacing: -0.8,
                                        color: ColorName.primaryColor,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),

                                  // Phone Label
                                  const Text(
                                    'Phone',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: -0.3,
                                      color: ColorName.primaryColor,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),

                                  // Phone Input
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),

                                  // Password Label
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: -0.4,
                                      color: ColorName.primaryColor,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),

                                  // Password Input
                                  CustomTextField(
                                    controller: passwordController,
                                    formValidationCubit: formValidationCubit,
                                    fieldId: passKey,
                                    fillColor: ColorName.lightGrey,
                                    isPassword: true,
                                    obscureTextCubit: obscureTextCubit,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05),

                                  // Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isFormValid
                                          ? () async {
                                              var data = {
                                                'phone': phoneController.text,
                                                'password':
                                                    passwordController.text,
                                              };
                                              await authCubit.logIn(data);
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isFormValid
                                            ? ColorName.primaryColor
                                            : Colors.grey.shade700,
                                        padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          letterSpacing: -0.9,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.015),

                                  // Remember Me + Forgot Password Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: remember,
                                            activeColor: Colors.white,
                                            checkColor: Colors.black,
                                            onChanged: (newValue) async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(
                                                  () => remember = newValue!);
                                              await prefs.setBool(
                                                  'remember', remember);
                                            },
                                          ),
                                          const Text(
                                            'Remember Me',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              letterSpacing: -0.9,
                                              color: ColorName.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, Routes.forgotPassword),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: -0.9,
                                            color: ColorName.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06),

                                  // Sign Up Footer
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Don\'t have an account yet? ',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.5,
                                          color: ColorName.primaryColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Sign Up',
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
                                                      context, Routes.signUp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                ],
                              ),
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
      ),
    );
  }
}
