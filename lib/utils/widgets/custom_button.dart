import '../../exports.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final double radius;
  final bool isIconButton;
  final bool isBorder;
  final Widget? widget;
  final double fontSize;
  final double? height;
  final double? width;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.textColor = ColorName.whiteColor,
    this.radius = 12,
    this.isIconButton = false,
    this.isBorder = false,
    this.widget,
    this.fontSize = 18,
    this.height = 45,
    this.width,
    this.fontWeight = FontWeight.normal
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? ScreenUtil().screenWidth,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: isBorder
                  ? const BorderSide(color: Colors.black)
                  : BorderSide.none,
            ),
          ),
          backgroundColor:
              WidgetStateProperty.all(color ?? ColorName.blue200),
          elevation: WidgetStateProperty.all(0.0),
        ),
        child: isIconButton
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget!,
                  SizedBox(
                    width: 15.w,
                  ),
                  AppText.medium(
                    text,
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ],
              )
            : AppText.medium(
                text,
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
      ),
    );
  }
}
