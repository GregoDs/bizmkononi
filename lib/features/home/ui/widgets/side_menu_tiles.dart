import '../../../../exports.dart';

class SideMenuTiles extends StatelessWidget {
  const SideMenuTiles({
    super.key, required this.title, required this.iconData,
  });

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        ListTile(
          leading: Icon(
            iconData,
            size: 30,
            color: Colors.white,
          ),
          title: AppText.medium(
            title,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
