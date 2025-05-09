// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:biz_mkononi/features/support/about.dart';
import 'package:biz_mkononi/features/support/contact_us.dart';
import 'package:flutter/cupertino.dart';

import 'package:biz_mkononi/features/categories/ui/categories.dart';
import 'package:biz_mkononi/features/customers/ui/customers.dart';
import 'package:biz_mkononi/features/employees/salaries/ui/salaries.dart';
import 'package:biz_mkononi/features/employees/ui/employees.dart';
import 'package:biz_mkononi/features/finance/income/ui/income.dart';
import 'package:biz_mkononi/features/finance/profits/ui/profits_insights.dart';
import 'package:biz_mkononi/features/insights/ui/overall_insight.dart';
import 'package:biz_mkononi/features/products/ui/products.dart';
import 'package:biz_mkononi/features/profile/ui/profile.dart';
import 'package:biz_mkononi/features/supplies/ui/supplies.dart';

import '../../../../exports.dart';
import '../../../finance/expenses/ui/expenses.dart';
import '../../../sales/ui/sales.dart';
import '../../../suppliers/ui/suppliers.dart';
import 'side_menu_tiles.dart';

class SideMenu extends StatefulWidget {
  const SideMenu(
      {super.key, required this.isBusiness, required this.onWidgetSelected});
  final bool isBusiness;
  final Function(Widget) onWidgetSelected;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<SideItem> businessMenuItems = [
    SideItem(
      title: 'Insights',
      iconData: Icons.graphic_eq,
      items: [
        SubCategoryMasterClass(
          widget: const SubCategory(
            title: 'Overview',
          ),
          navigationWidget: const OverallInsight(),
        ),
      ],
    ),
    SideItem(
        title: 'Products-Categories',
        iconData: Icons.shopping_basket,
        items: [
          SubCategoryMasterClass(
            widget: const SubCategory(
              title: 'Categories',
            ),
            navigationWidget: const Categories(),
          ),
          SubCategoryMasterClass(
            widget: const SubCategory(
              title: 'Products',
            ),
            navigationWidget: const Products(),
          ),
        ]),
    SideItem(title: 'Suppliers', iconData: Icons.people, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Suppliers',
        ),
        navigationWidget: const Suppliers(),
      ),
    ]),
    SideItem(title: 'Supplies', iconData: Icons.wrap_text, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Supplies',
        ),
        navigationWidget: const Supplies(),
      ),
    ]),
    SideItem(title: 'Customers', iconData: Icons.people, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Customers',
        ),
        navigationWidget: const Customers(),
      ),
    ]),
    SideItem(title: 'Sales', iconData: Icons.shopping_cart, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Sales',
        ),
        navigationWidget: const Sales(),
      ),
    ]),
    SideItem(title: 'Employees', iconData: CupertinoIcons.person_2, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Employees',
        ),
        navigationWidget: const Employees(),
      ),
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Salaries',
        ),
        navigationWidget: const Salaries(),
      ),
    ]),
    SideItem(title: 'Finance', iconData: CupertinoIcons.money_dollar, items: [
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Profit Analytics',
        ),
        navigationWidget: const ProfitsInsight(),
      ),
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Expenses',
        ),
        navigationWidget: const Expenses(),
      ),
      SubCategoryMasterClass(
        widget: const SubCategory(
          title: 'Income',
        ),
        navigationWidget: const Income(),
      ),
    ]),
  ];

  List<OverallSideItem> overallSideItems = [
    OverallSideItem(
      title: 'Profile',
      iconData: Icons.person,
      navigationWidget: const Profile(),
    ),
    OverallSideItem(
      title: 'About Us',
      iconData: Icons.info,
      navigationWidget: const About(),
    ),
    OverallSideItem(
      title: 'Contact Us',
      iconData: Icons.call,
      navigationWidget: const Contact(),
    ),
  ];

  int selectedItem = -1;
  // int selectedHome = -1;
  String? phone;
  String? name;

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    phone = prefs.getString('phone');
    name = prefs.getString('name');
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 65),
        width: 288,
        height: ScreenUtil().screenHeight,
        color: const Color(0xFF17203A),
        child: Column(
          children: [
            InfoCard(
              name: name ?? 'Loading',
              profession: phone ?? 'Loading',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: const Divider(
                color: Colors.white24,
                height: 2,
                indent: 15,
                endIndent: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() => selectedItem = -1);
                widget.isBusiness
                    ? Navigator.pop(context)
                    : widget.onWidgetSelected(const Businesses());
              },
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    height: 56,
                    width: selectedItem == -1 ? 288 : 0,
                    left: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorName.blue200,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SideMenuTiles(
                    title: "Businesses",
                    iconData: CupertinoIcons.briefcase,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: const Divider(
                color: Colors.white24,
                height: 2,
                indent: 15,
                endIndent: 15,
              ),
            ),
            Expanded(
              child: widget.isBusiness
                  ? MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: businessMenuItems.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                height: 56,
                                width: selectedItem == i ? 288 : 0,
                                left: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: ColorName.blue200,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  key: Key(i.toString()),
                                  onExpansionChanged: (value) {
                                    setState(() => selectedItem = i);
                                  },
                                  iconColor: Colors.white,
                                  leading: Icon(
                                    businessMenuItems[i].iconData,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  title: AppText.medium(
                                    businessMenuItems[i].title,
                                    color: Colors.white,
                                  ),
                                  initiallyExpanded: selectedItem == i,
                                  children: List.generate(
                                    businessMenuItems[i].items.length,
                                    (index) => GestureDetector(
                                      onTap: () => widget.onWidgetSelected(
                                          businessMenuItems[i]
                                              .items[index]
                                              .navigationWidget),
                                      child: businessMenuItems[i]
                                          .items[index]
                                          .widget,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: overallSideItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() => selectedItem = index);
                                widget.onWidgetSelected(
                                    overallSideItems[index].navigationWidget);
                              },
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 300),
                                    height: 56,
                                    width: selectedItem == index ? 288 : 0,
                                    left: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: ColorName.blue200,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SideMenuTiles(
                                    title: overallSideItems[index].title,
                                    iconData: overallSideItems[index].iconData,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Column(
              children: [
                const Divider(
                  color: Colors.white24,
                  height: 2,
                  indent: 15,
                  endIndent: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    prefs.setBool('firstLaunch', false);
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, Routes.signIn);
                    }
                  },
                  child: const SideMenuTiles(
                    title: "Logout",
                    iconData: CupertinoIcons.power,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SubCategoryMasterClass {
  Widget widget;
  Widget navigationWidget;
  SubCategoryMasterClass({
    required this.widget,
    required this.navigationWidget,
  });
}

class SubCategory extends StatelessWidget {
  const SubCategory({
    super.key,
    required this.title,
  });

  final String title;
  // final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 5,
        width: 5,
        decoration: const BoxDecoration(
          color: ColorName.whiteColor,
          shape: BoxShape.circle,
        ),
      ),
      title: AppText.medium(
        title,
        color: ColorName.mainGrey,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      // onTap: onTap,
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.profession,
  });

  final String name, profession;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        profession,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class SideItem {
  String title;
  IconData iconData;
  List<SubCategoryMasterClass> items;
  SideItem({required this.title, required this.iconData, required this.items});
}

// class CustomExpansionTile extends StatefulWidget {
//   final Widget title;
//   final Widget? leading;
//   final Widget trailing;
//   final Widget expandedChild;
//   final bool initiallyExpanded;
//   final EdgeInsetsGeometry? contentPadding;
//   final Color? backgroundColor;
//   final Function(bool) onExpansionChanged;

//   const CustomExpansionTile({
//     Key? key,
//     required this.title,
//     this.leading,
//     required this.trailing,
//     required this.expandedChild,
//     this.initiallyExpanded = false,
//     this.contentPadding,
//     this.backgroundColor,
//     required this.onExpansionChanged,
//   }) : super(key: key);

//   @override
//   _CustomExpansionTileState createState() => _CustomExpansionTileState();
// }

// class _CustomExpansionTileState extends State<CustomExpansionTile> {
//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _isExpanded = widget.initiallyExpanded;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         key: widget.key,
//         title: widget.title,
//         leading: widget.leading,
//         trailing: widget.trailing,
//         childrenPadding: widget.contentPadding,
//         backgroundColor: widget.backgroundColor,
//         initiallyExpanded: widget.initiallyExpanded,
//         onExpansionChanged: (isExpanded) {
//           setState(() {
//             _isExpanded = isExpanded;
//           });
//           widget.onExpansionChanged(isExpanded);
//         },
//         children: [
//           widget.expandedChild,
//         ],
//         tilePadding: EdgeInsets.zero,
//       ),
//     );
//   }
// }
class OverallSideItem {
  final String title;
  final IconData iconData;
  final Widget navigationWidget;

  OverallSideItem({
    required this.title,
    required this.iconData,
    required this.navigationWidget,
  });
}

class SideMenuTiles1 extends StatefulWidget {
  const SideMenuTiles1(
      {super.key,
      required this.title,
      required this.iconData,
      required this.isExpanded});

  final String title;
  final IconData iconData;
  final bool isExpanded;

  @override
  State<SideMenuTiles1> createState() => _SideMenuTiles1State();
}

class _SideMenuTiles1State extends State<SideMenuTiles1> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          height: 56,
          width: selected ? 288 : 0,
          left: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: ColorName.blue200,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        widget.isExpanded
            ? Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() => selected = !selected);
                  },
                  iconColor: Colors.white,
                  leading: Icon(
                    widget.iconData,
                    size: 30,
                    color: Colors.white,
                  ),
                  title: AppText.medium(
                    widget.title,
                    color: Colors.white,
                  ),
                  children: [
                    ListTile(
                      title: AppText.medium(
                        'Overview',
                        color: ColorName.whiteColor,
                      ),
                      onTap: () {
                        // Navigate to another page or perform some action
                      },
                    ),
                  ],
                ),
              )
            : ListTile(
                leading: Icon(
                  widget.iconData,
                  size: 30,
                  color: Colors.white,
                ),
                title: AppText.medium(
                  widget.title,
                  color: Colors.white,
                ),
              ),
      ],
    );
  }
}
