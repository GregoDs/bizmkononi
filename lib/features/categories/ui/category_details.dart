import '../../../exports.dart';
import '../cubit/category_cubit.dart';
import '../repo/categories_repo.dart';
import 'add_category.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  final CategoryCubit categoryCubit = CategoryCubit(CategoriesRepo());

  @override
  void initState() {
    categoryCubit.getSingleCategory(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.lightGrey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: ColorName.blue200,
        centerTitle: true,
        title: AppText.medium(
          'Category Details',
        ),
      ),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        bloc: categoryCubit,
        listener: (context, state) {
          if (state is CategoryDeleted) {
            showSuccess(context, 'Good job, item deleted Successfully');
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorName.primaryColor,
                      ),
                    );
                  },
                );
          } else if (state is CategoryError) {
            return Center(
              child: AppText.medium(state.message),
            );
          } else if (state is CategorySingleLoaded) {
            var data = state.data;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    DetailsSection(
                      image: data.imageUrl,
                      tiles: [
                        DetailTile(
                          title: 'Name',
                          trailing: data.name!,
                        ),
                        DetailTile(
                          title: 'Date Added',
                          trailing: convertToHumanReadableDate(
                              data.createdAt.toString()),
                        ),
                        DetailTile(
                          title: 'Description',
                          trailing: data.description!,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            );
          }
    
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<CategoryCubit, CategoryState>(
        bloc: categoryCubit,
        builder: (context, state) {
          if (state is CategorySingleLoaded) {
            return Container(
              margin: EdgeInsets.only(left: 30.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCategory(
                                data: state.data,
                              ),
                            ),
                          );
                          if (result != null && result == true) {
                            categoryCubit
                                .getSingleCategory(widget.categoryId);
                          }
                        },
                        text: "Edit"),
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      onTap: () => _showMyDialog(context, widget.categoryId),
                      text: "Delete",
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
    
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Future<void> _showMyDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to remove the Category ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  overlayColor:
                      WidgetStateProperty.all<Color>(Colors.redAccent),
                ),
                child: const Text('Remove'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await categoryCubit.deleteCategory(id);
                }),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
