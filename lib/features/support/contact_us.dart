
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../../../exports.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    // Future<void> _launchEmail(String email) async {
    //   if (kDebugMode) {
    //     print(email);
    //   }
    //   var url = Uri.parse("mailto:$email");
    //   if (await canLaunchUrl(url)) {
    //     await launchUrl(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

    List<Item> emails = [
      Item(
        title: 'Service support',
        descr:
            'For assistance with any questions or issues, contact our support team',
        reach: RichText(
          text: TextSpan(
            children: [
              AppTextSpan.medium('Reach us at: '),
              AppTextSpan.small('  '),
              TextSpan(
                text: 'support@bizMkononi.in',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // _launchEmail('');
                  },
              ),
            ],
          ),
        ),
      ),
    ];

    List<String> socials = [
      Assets.images.facebook.path,
      Assets.images.twitter.path,
      Assets.images.youtube.path,
      Assets.images.whatsapp.path,
      Assets.images.linkedin.path,
      Assets.images.insta.path,
    ];

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.blue200,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          leading: const SizedBox(),
          title: AppText.large(
            'Contact Us',
            fontSize: 20,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: ScreenUtil().screenHeight - 150,
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(15.h),
                  decoration: BoxDecoration(
                    color: ColorName.whiteColor,
                    border: Border.all(
                      color: ColorName.blackColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                                color: ColorName.mainGrey.withOpacity(0.2),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.phone),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          AppText.large(
                            'Phone support',
                            fontSize: 16,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      AppText.medium(
                        'call us at +91 - 7396744187',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(15.h),
                  decoration: BoxDecoration(
                    color: ColorName.whiteColor,
                    border: Border.all(
                      color: ColorName.blackColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              color: ColorName.mainGrey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.email_outlined),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          AppText.large(
                            'Email',
                            fontSize: 16,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: emails.length,
                          itemBuilder: (context, index) {
                            var item = emails[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.medium(item.title),
                                AppText.small(item.descr),
                                item.reach,
                                const SizedBox(
                                  height: 5,
                                ),
                                index == emails.length - 1
                                    ? const SizedBox()
                                    : const Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: ColorName.mainGrey,
                                        thickness: 0.2,
                                      ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                AppText.large(
                  'Follow Us',
                  fontSize: 18,
                ),
                Center(
                  child: SizedBox(
                    height: 80.h,
                    child: ListView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: socials.length,
                        itemBuilder: (context, index) {
                          var item = socials[index];
                          return Container(
                            margin: EdgeInsets.only(right: 15.w),
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(item),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  final String title;
  final String descr;
  final Widget reach;
  Item({
    required this.title,
    required this.descr,
    required this.reach,
  });
}
