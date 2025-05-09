import 'package:biz_mkononi/features/insights/ui/overall_insight.dart';

import '../../../utils/globals/global.dart' as globals;
import '../../../exports.dart';

class BusinessLandingPage extends StatefulWidget {
  const BusinessLandingPage({super.key});

  @override
  State<BusinessLandingPage> createState() => _BusinessLandingPageState();
}

class _BusinessLandingPageState extends State<BusinessLandingPage>
    with SingleTickerProviderStateMixin {
  bool isSideBarClosed = true;
  late AnimationController _animationController;
  late Animation<double> opacityAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    super.initState();
  }

  void toggleDrawer() {
    if (isSideBarClosed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isSideBarClosed = !isSideBarClosed;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          globals.selectedBusinessWidget ?? const OverallInsight(),
          if (!isSideBarClosed)
            FadeTransition(
              opacity: opacityAnimation,
              child: GestureDetector(
                onTap: toggleDrawer,
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Dimmed background
                ),
              ),
            ),
          SlideTransition(
            position: slideAnimation,
            child: Container(
              width: 288,
              color: Colors.white,
              child: SideMenu(
                isBusiness: true,
                onWidgetSelected: (widget) {
                  setState(() {
                    globals.selectedBusinessWidget = widget;
                    toggleDrawer();
                  });
                },
              ),
            ),
          ),
          SafeArea(
            child: NavBtn(
              press: toggleDrawer,
              isSideBarClosed: isSideBarClosed,
            ),
          ),
        ],
      ),
    );
  }
}

class NavBtn extends StatelessWidget {
  const NavBtn({
    super.key,
    required this.press,
    required this.isSideBarClosed,
  });

  final VoidCallback press;
  final bool isSideBarClosed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SafeArea(
        child: isSideBarClosed
            ? Container(
                margin: const EdgeInsets.only(left: 16),
                height: 30,
                width: 30,
                child: Image(
                  image: AssetImage(Assets.images.drawer.path),
                  color: Colors.black,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
