import 'package:biz_mkononi/features/profile/repo/profile_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../exports.dart';
import '../cubit/profile_cubit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FormValidationCubit formValidationCubit = FormValidationCubit();
  final ProfileCubit profileCubit = ProfileCubit(ProfileRepo());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final nameKey = 'profileName';
  final emailKey = 'profileEmail';
  final phoneKey = 'profilePhone';

  @override
  void initState() {
    profileCubit.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorName.blue200,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ColorName.lightGrey,
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: ColorName.blue200,
          centerTitle: true,
          title: AppText.medium(
            'Profile',
          ),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            if (state is ProfileEdit) {
              showSuccess(context, 'Good job, changes made Successfully');
              profileCubit.getProfile();
              // print('Done');
              // Navigator.pop(context);
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(
                        left: 23,
                        right: 23,
                        bottom: 23,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return const DecoratedBox(
                      decoration: BoxDecoration(
                        color: ColorName.primaryColor,
                      ),
                    );
                  },
                ),
              );
            }
            if (state is ProfileLoaded) {
              nameController.text = state.profileModel.name!;
              phoneController.text = state.profileModel.phone!;
              emailController.text = state.profileModel.email!;
              formValidationCubit.validateField(nameKey, true);
              formValidationCubit.validateField(emailKey, true);
              formValidationCubit.validateField(phoneKey, true);
              return BlocBuilder<FormValidationCubit, Map<String, bool>>(
                bloc: formValidationCubit,
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          child: Stack(
                            children: [
                              Container(
                                height: 90.h,
                                decoration: const BoxDecoration(
                                  color: ColorName.blue200,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 40,
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    AppText.medium(
                                      nameController.text,
                                      color: ColorName.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.medium(
                                'Name',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: nameController,
                                formValidationCubit: formValidationCubit,
                                fieldId: nameKey,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Email',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: emailController,
                                formValidationCubit: formValidationCubit,
                                fieldId: emailKey,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              AppText.medium(
                                'Phone Number',
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              CustomTextField(
                                controller: phoneController,
                                formValidationCubit: formValidationCubit,
                                fieldId: phoneKey,
                                fillColor: ColorName.textfieldColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
        floatingActionButton:
            BlocBuilder<FormValidationCubit, Map<String, bool>>(
          bloc: formValidationCubit,
          builder: (context, state) {
            bool isFormValid = formValidationCubit.isFormValid();
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              width: 300.w,
              child: CustomButton(
                onTap: () => profileCubit.updateProfile({
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text
                }),
                text: 'Edit',
                color:
                    isFormValid ? ColorName.primaryColor : ColorName.mainGrey,
                radius: 20,
                fontWeight: FontWeight.normal,
                textColor:
                    isFormValid ? ColorName.whiteColor : ColorName.lightGrey,
              ),
            );
          },
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
