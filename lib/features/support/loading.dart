import 'package:biz_mkononi/exports.dart';

class LoadingPage extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const LoadingPage({super.key, required this.onLoadingComplete, required Color color});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // // Simulate loading for 3 seconds, then trigger the callback
    // Future.delayed(const Duration(seconds: 60), () {
    //   widget.onLoadingComplete();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorName.whiteColor,
      body: Stack(
        children: [
          // // Top Left Decoration (same as SignIn page)
          // Positioned(
          //   top: -10,
          //   right: -70,
          //   child: Image.asset(
          //     'assets/images/vectorsplash.png',
          //     width: screenWidth * 0.6,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // // Bottom Decoration (same as SignIn page)
          // Positioned(
          //   bottom: -40,
          //   left: -120,
          //   child: Image.asset(
          //     'assets/images/vectorsplash.png',
          //     width: screenWidth * 0.7,
          //   ),
          // ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  Assets.images.logotext.path,
                  height: screenHeight * 0.10,
                ),
                SizedBox(height: screenHeight * 0.20),
                // Features Row (similar to About page)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(Assets.images.business.path),
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(width: 15.w),
                            SizedBox(
                              width: 15.w,
                              child: const Divider(
                                color: ColorName.primaryColor,
                              ),
                            ),
                            SizedBox(width: 15.w),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: AppText.small(
                            '100%\nBusiness\nInsights',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage(Assets.images.aipowered.path),
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(width: 15.w),
                            SizedBox(
                              width: 15.w,
                              child: const Divider(
                                color: ColorName.primaryColor,
                              ),
                            ),
                            SizedBox(width: 15.w),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: AppText.small(
                            'AI Powered',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage(Assets.images.view.path),
                              height: 40,
                              width: 40,
                            ),
                            SizedBox(width: 15.w),
                            SizedBox(
                              width: 15.w,
                              child: const Divider(
                                color: ColorName.primaryColor,
                              ),
                            ),
                            SizedBox(width: 15.w),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: AppText.small(
                            '360°\nCustomer\nview',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(Assets.images.revenuecharts.path),
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: AppText.small(
                            'Revenue\nProjection\nCharts',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                // Description
                AppText.medium(
                  'Biz Mkononi is an AI powered insights platform that provides decision making tools, solutions and analytics to the small and medium enterprises in Kenya and the rest of the world.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.09),
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
                      const SizedBox(height: 5),
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