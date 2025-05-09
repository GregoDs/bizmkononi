// import 'dart:math';

// import '../../../utils/globals/global.dart' as globals;
// import '../../../exports.dart';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage>
//     with SingleTickerProviderStateMixin {
//   bool isSideBarClosed = true;
//   late AnimationController _animationController;
//   late Animation<double> animation;
//   late Animation<double> scalAnimation;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     )..addListener(() {
//         setState(() {});
//       });

//     animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.fastOutSlowIn));

//     scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.fastOutSlowIn));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorName.primaryColor,
//       resizeToAvoidBottomInset: false,
//       extendBody: true,
//       body: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.fastOutSlowIn,
//             width: 288,
//             left: isSideBarClosed ? -288 : 0,
//             height: MediaQuery.sizeOf(context).height,
//             top: 0,
//             child: SideMenu(
//               isBusiness: false,
//               onWidgetSelected: (widget) {
//                 setState(() {
//                   globals.selectedAppWidget = widget;
//                   if (isSideBarClosed) {
//                     _animationController.forward();
//                   } else {
//                     _animationController.reverse();
//                   }
//                   isSideBarClosed = !isSideBarClosed;
//                 });
//               },
//             ),
//           ),
//           Transform(
//             alignment: Alignment.center,
//             transform: 
//             Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(animation.value - 30 * animation.value * pi / 180),
//             child: Transform.translate(
//               offset: Offset(animation.value * 265, 0),
//               child: Transform.scale(
//                 scale: scalAnimation.value,
//                 child: ClipRRect(
//                   borderRadius: isSideBarClosed
//                       ? BorderRadius.zero
//                       : const BorderRadius.all(Radius.circular(24)),
//                   child: globals.selectedAppWidget ?? const Businesses(),
//                 ),
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.fastOutSlowIn,
//             left: isSideBarClosed ? 0 : 220,
//             top: 16,
//             child: NavBtn(
//               press: () {
//                 if (isSideBarClosed) {
//                   _animationController.forward();
//                 } else {
//                   _animationController.reverse();
//                 }
//                 setState(() {
//                   isSideBarClosed = !isSideBarClosed;
//                 });
//               },
//               isSideBarClosed: isSideBarClosed,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NavBtn extends StatelessWidget {
//   const NavBtn({
//     super.key,
//     required this.press,
//     required this.isSideBarClosed,
//   });

//   final VoidCallback press;
//   final bool isSideBarClosed;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: SafeArea(
//         child: isSideBarClosed
//             ? Container(
//                 margin: const EdgeInsets.only(left: 16),
//                 height: 30,
//                 width: 30,
//                 child: Image(
//                   image: AssetImage(Assets.images.drawer.path),
//                   color: Colors.black,
//                 ),
//               )
//             : Container(
//                 padding: const EdgeInsets.only(
//                   left: 12,
//                   top: 12,
//                   right: 12,
//                   bottom: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ColorName.primaryColor.withOpacity(0.8),
//                   borderRadius: const BorderRadius.all(Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: ColorName.primaryColor.withOpacity(0.3),
//                       offset: const Offset(0, 20),
//                       blurRadius: 20,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.close,
//                   size: 30,
//                   color: ColorName.whiteColor,
//                 ),
//               ),
//       ),
//     );
//   }
// }

import '../../../utils/globals/global.dart' as globals;
import '../../../exports.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
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
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
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
          // Main content remains unaffected
          globals.selectedAppWidget ?? const Businesses(),
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
                isBusiness: false,
                onWidgetSelected: (widget) {
                  setState(() {
                    globals.selectedAppWidget = widget;
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