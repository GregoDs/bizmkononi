import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Your design size (default is 360x690)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return child!;
      },
      child: child,
    );
  }
}