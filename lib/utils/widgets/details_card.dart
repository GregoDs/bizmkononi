import '../../exports.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    super.key,
    this.image,
    this.isperson,
    this.isWithoutImage,
    required this.tiles,
  });
  final bool? isWithoutImage;
  final bool? isperson;
  final String? image;
  final List<DetailTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // isWithoutImage != null && isWithoutImage == true
          //     ? const SizedBox.shrink()
          //     : isperson!= null && isperson == true
          //         ? image == null
          //             ? Padding(
          //                 padding: EdgeInsets.all(12.h),
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     shape: BoxShape.circle,
          //                     border: Border.all(
          //                       color: ColorName.mainGrey,
          //                       width: 2.0,
          //                     ),
          //                   ),
          //                   child: const CircleAvatar(
          //                     radius: 50,
          //                     child: Icon(
          //                       Icons.person,
          //                       size: 50,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : Padding(
          //                 padding: EdgeInsets.all(12.h),
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     shape: BoxShape.circle,
          //                     border: Border.all(
          //                       color: ColorName.mainGrey,
          //                       width: 2.0,
          //                     ),
          //                   ),
          //                   child: CircleAvatar(
          //                     radius: 50,
          //                     backgroundImage: NetworkImage(image!),
          //                   ),
          //                 ),
          //               )
          //         : image == null
          //             ? Container(
          //                 height: 80,
          //                 decoration: const BoxDecoration(
          //                   color: ColorName.lightGrey,
          //                   borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(15),
          //                     topRight: Radius.circular(15),
          //                   ),
          //                 ),
          //               )
          //             : Container(
          //                 height: 150,
          //                 decoration: BoxDecoration(
          //                   borderRadius: const BorderRadius.only(
          //                     topLeft: Radius.circular(15),
          //                     topRight: Radius.circular(15),
          //                   ),
          //                   image: DecorationImage(
          //                     image: NetworkImage(image!),
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //               ),
          SizedBox(
            height: 10.h,
          ),
          for (int i = 0; i < tiles.length - 1; i++)
            Column(
              children: [
                ListTile(
                  leading: AppText.medium(tiles[i].title),
                  trailing: AppText.medium(
                    capitalizeWord(tiles[i].trailing),
                    color: ColorName.primaryColor,
                  ),
                ),
                const Divider(
                  color: ColorName.mainGrey,
                  height: 2,
                  indent: 15,
                  endIndent: 15,
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium(tiles.last.title),
                SizedBox(
                  height: 8.h,
                ),
                AppText.medium(
                  capitalizeWord(
                    tiles.last.trailing,
                  ),
                  color: ColorName.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTile {
  final String title;
  final String trailing;
  DetailTile({
    required this.title,
    required this.trailing,
  });
}
