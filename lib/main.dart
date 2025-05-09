import 'package:biz_mkononi/features/onboarding/splash.dart';
import 'package:biz_mkononi/utils/widgets/responsive_wrapper.dart';
import 'package:flutter/services.dart';


import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: ColorName.primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}