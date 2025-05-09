import 'dart:async';
import 'package:biz_mkononi/exports.dart';
import 'package:biz_mkononi/utils/cache/shared_preferences.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late LocalStorage localStorage;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize local storage
    localStorage = await LocalStorage.init();
    
    // Navigate after delay
    Timer(
      const Duration(seconds: 6),
      () {
        if (localStorage.isFirstLaunch) {
          Navigator.pushReplacementNamed(context, Routes.onBoarding);
        } else if (localStorage.isLoggedIn) {
          Navigator.pushReplacementNamed(context, Routes.landingScreen);
        } else {
          Navigator.pushReplacementNamed(context, Routes.signIn);
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.primaryColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Top Right Decoration
            Positioned(
              top: -10,
              right: -70,
              child: Image.asset(
                'assets/images/vectorsplash.png',
                width: 230.w,
                fit: BoxFit.cover,
              ),
            ),

            // Bottom Left Decoration
            Positioned(
              bottom: -40,
              left: -50,
              child: Image.asset(
                'assets/images/vectorsplash.png',
                width: 240.w,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: animation,
                    child: Image.asset(
                      'assets/images/BIZ_MKONONI.png',
                      width: 140.w,
                      height: 270.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppText.medium(
                      'Better Decisions Powered By Better \nInsights',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ColorName.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}