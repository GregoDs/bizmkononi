import '../../exports.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({
    super.key,
    required this.index,
    required this.length,
    required this.holder,
    required this.title,
    required this.subtitle,
    this.subtitle1,
    this.onTap,
  });

  final int index;
  final int length;
  final String holder;
  final String title;
  final String subtitle;
  final String? subtitle1;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == length - 1
          ? EdgeInsets.only(left: 15.w, right: 15.w, top: 5.h, bottom: 80.h)
          : EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListTile(
                splashColor: Colors.transparent,
                tileColor: Colors.transparent,
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: ColorName.blue200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppText.large(
                      holder,
                      fontWeight: FontWeight.normal,
                      color: ColorName.whiteColor,
                    ),
                  ),
                ),
                title: AppText.medium(title),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.small(subtitle),
                      subtitle1 == null ? const SizedBox() :
                      AppText.small(subtitle1!),
                    ],
                  ),
                ),
                onTap: onTap,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: AppText.medium(
                      'View',
                      color: ColorName.blue200,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
