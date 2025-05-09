import '../../exports.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: const BoxDecoration(color: ColorName.whiteColor),
              ),
              PageView(
                physics: const ClampingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                controller: _pageController,
                children: <Widget>[
                  makePage(
                    image: Assets.images.biAnalytics.path,
                    title: 'Business Intelligence',
                    content:
                        'Insights are accurate so that a business owner\nis empowered to make the best decisions for\ntheir enterprise.',
                  ),
                  makePage(
                      image: Assets.images.analytics.path,
                      title: 'Big Data Analytics',
                      content:
                          'Biz Mkononi is integrating potentially over\n10,000 data sets and processing north of 100\ntrillion data points in weeks'),
                  makePage(
                      image: Assets.images.riskAnalysis.path,
                      title: '360° Customer view &\nChurn Risk Analysis',
                      content:
                          'Classify your customers, avoid customer churn\nrate while improving the return rate, upsell,\nresell and have a holistic view of your\ncustomers.'),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w),
                child: currentIndex == 2
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 300,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                localStorage.setBool('firstLaunch', false);
                                if (context.mounted) {
                                  Navigator.pushNamed(context, Routes.signIn);
                                }
                              },
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: ColorName.primaryColor,
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                elevation: WidgetStateProperty.all(0.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.medium(
                                    'Get Started',
                                    color: ColorName.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            currentIndex == 0
                                ? GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        currentIndex + 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorName.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: AppText.medium(
                                        'Skip',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: ColorName.blackColor,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  currentIndex + 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 16),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                decoration: BoxDecoration(
                                  color: ColorName.lightGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AppText.medium(
                                  'Next',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: ColorName.blackColor,
                                ),
                              ),
                            ),
                          ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            height: 130.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 900),
            child: AppText.large(
              title,
              textAlign: TextAlign.center,
              color: ColorName.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: AppText.medium(
              content,
              textAlign: TextAlign.center,
              color: ColorName.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          currentIndex == 2
              ? const SizedBox()
              : Container(
                margin: EdgeInsets.only(top: 30.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator(),
                  ),
              ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorName.primaryColor,
          borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
