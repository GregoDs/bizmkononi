import 'dart:async';

import '../../exports.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int _currentIndex = 0;
  late Timer _timer;

  final List<Map<String, String>> _features = [
    {
      'image': Assets.images.business.path,
      'text': '100%\nBusiness\nInsights',
    },
    {
      'image': Assets.images.aipowered.path,
      'text': 'AI Powered',
    },
    {
      'image': Assets.images.view.path,
      'text': '360°\nCustomer\nview',
    },
    {
      'image': Assets.images.revenuecharts.path,
      'text': 'Revenue\nProjection\nCharts',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _features.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  Assets.images.logotext.path,
                  height: screenHeight * 0.08,
                ),
                SizedBox(height: screenHeight * 0.24),

                // Animated Feature
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Column(
                    key: ValueKey<int>(_currentIndex),
                    children: [
                      Image.asset(
                        _features[_currentIndex]['image']!,
                        height: 120,
                        width: 140,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _features[_currentIndex]['text']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(

                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Description
                AppText.medium(
                  'Biz Mkononi is an AI powered insights platform that provides decision making tools, solutions and analytics to the small and medium enterprises in Kenya and the rest of the world.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.12),

                // Loading Indicator and Text
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SpinKitWave(
                        itemBuilder: (BuildContext context, int index) {
                          return const DecoratedBox(
                            decoration: BoxDecoration(
                              color: ColorName.primaryColor,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      AppText.medium(
                        'Signing you in, please wait',
                        textAlign: TextAlign.center,
                        color: ColorName.primaryColor,
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
  }
}
