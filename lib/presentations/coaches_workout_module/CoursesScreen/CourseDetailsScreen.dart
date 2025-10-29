import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/CoursesScreen/SessionCard.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/AddLiveSession.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/Provider/LiveSessionProvider2.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/live_session2/SessionScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../data/models/course_details_response.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';

class CourseDetailsScreen extends StatefulWidget {
  int courseId;

  CourseDetailsScreen({super.key, required this.courseId});
  @override
  State<StatefulWidget> createState() {
    return CourseDetailsScreenState();
  }
}

class CourseDetailsScreenState extends State<CourseDetailsScreen> {
  CoachServicesProvider coachServicesProvider = getIt();
  @override
  void initState() {
    super.initState();
    coachServicesProvider.getCourseDetails(widget.courseId);
  }

  @override
  void dispose() {
    super.dispose();
    coachServicesProvider.courseDetailsResponse = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<CoachServicesProvider>(
          builder: (context, provider, _) {
            return CustomAppBar(
              showToolBar: true,
              showBackArrow: true,
              title:
                  provider.courseDetailsResponse == null
                      ? ""
                      : provider.courseDetailsResponse!.data.title,
              elevation: 1,
              isMainBack: true,
              bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
            );
          },
        ),
      ),

      body: Consumer<CoachServicesProvider>(
        builder: (context, provider, _) {
          return provider.courseDetailsResponse == null
              ? const Center(child: CustomText(title: "No Data Founded"))
              : Padding(
                padding: const EdgeInsetsDirectional.all(20),
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [];
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Dimens.width,
                        height: Dimens.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            provider.courseDetailsResponse!.data.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            title: "Price:".tr(),
                            fontSize: 20,
                            fontColor:
                                AppTheme.isDarkMode()
                                    ? greyColor
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            title:
                                "${provider.courseDetailsResponse!.data.price} ${"SAR".tr()}",
                            fontSize: 20,
                            fontColor:
                                AppTheme.isDarkMode()
                                    ? greyColor
                                    : Colors.black,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      CustomText(
                        title: "Course Description".tr(),
                        fontSize: 20,
                        fontColor:
                            AppTheme.isDarkMode() ? greyColor : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 15),
                      CustomText(
                        title: provider.courseDetailsResponse!.data.description,
                        fontSize: 15,
                        fontColor: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      provider.courseDetailsResponse!.data.sessions.isNotEmpty
                          ? CustomText(
                            title: "Sessions".tr(),
                            fontColor:
                                AppTheme.isDarkMode()
                                    ? greyColor
                                    : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                          : Container(),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            Session currentSesssion =
                                provider
                                    .courseDetailsResponse!
                                    .data
                                    .sessions[index];
                            return InkWell(
                              child: SessionCard(
                                session: currentSesssion,
                                width: Dimens.width,
                                borderRadius: 8,
                                deleteSession: () {
                                  _showDeleteDilaog(
                                    context,
                                    provider,
                                    currentSesssion.id,
                                  );
                                },
                              ),
                              onLongPress: () {
                                _showDeleteDilaog(
                                  context,
                                  provider,
                                  currentSesssion.id,
                                );
                              },
                              onTap: () {
                                if (currentSesssion.type == "live") {
                                  final provider =
                                      getIt<LiveSessionProvider2>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ChangeNotifierProvider.value(
                                                value: provider,
                                                child: SessionScreen(
                                                  channelName:
                                                      currentSesssion
                                                          .channelName,
                                                  sessionId: currentSesssion.id,
                                                  userId: provider.userSessionId??0,
                                                ),
                                              ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemCount:
                              provider.courseDetailsResponse == null
                                  ? 0
                                  : provider
                                      .courseDetailsResponse!
                                      .data
                                      .sessions
                                      .length,
                        ),
                      ),

                      CustomButton(
                        title: "Add New Session".tr(),
                        fontWeight: FontWeight.bold,
                        onTap: () {
                          _showDialog(context, provider);
                        },
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, CoachServicesProvider provider) {
    showDialog(
      context: context,
      builder: (widgetContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          child: Container(
            width: Dimens.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.isDarkMode() ? dark : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 20,
                children: [
                  CustomText(
                    title: "Choose Session Type".tr(),
                    fontSize: 15,
                    fontColor: AppTheme.isDarkMode() ? greyColor : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    child: Row(
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.video_call_rounded,
                          size: 40,
                          color: mainColor,
                        ),
                        CustomText(
                          title: "Upload Video".tr(),
                          fontSize: 20,
                          fontColor:
                              AppTheme.isDarkMode() ? greyColor : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showAccecptanceDialog(context, provider);
                    },
                  ),

                  InkWell(
                    child: Row(
                      spacing: 5,
                      children: [
                        SvgPicture.asset(
                          'assets/images/svg/play_icon.svg',
                          color: mainColor,
                          width: 30,
                          height: 30,
                        ),
                        CustomText(
                          title: "Open Live Session".tr(),
                          fontSize: 20,
                          fontColor:
                              AppTheme.isDarkMode() ? greyColor : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    onTap: () {
                      final provider = getIt<LiveSessionProvider2>();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider.value(
                                value: provider,
                                child: AddLiveSessionScreen(
                                  courseId: widget.courseId,
                                ),
                              ),
                        ),
                      ).then((value) {
                        CoachServicesProvider coachProvider = getIt();
                        coachProvider.getCourseDetails(widget.courseId);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openGallery(CoachServicesProvider provider) async {
    ImagePicker imagePicker = ImagePicker();
    final file = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      File videoFile = File(file.path);
      provider.uploadeSessionVideo(widget.courseId, file.name, videoFile);
    }
  }

  void _showAccecptanceDialog(
    BuildContext context,
    CoachServicesProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CustomText(title: "do you want it free".tr()),
          actions: [
            TextButton(
              onPressed: () {
                provider.updateIsFree(true);
                _openGallery(provider);
                Navigator.pop(context);
              },
              child: CustomText(title: "yes".tr()),
            ),
            TextButton(
              onPressed: () {
                provider.updateIsFree(false);
                _openGallery(provider);
                Navigator.pop(context);
              },
              child: CustomText(title: "no".tr()),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDilaog(
    BuildContext context,
    CoachServicesProvider provider,
    int sessionId,
  ) {
    showDialog(
      context: context,
      builder: (builderContext) {
        return AlertDialog(
          content: CustomText(title: "do you want to delete this session".tr()),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(builderContext).pop();
                await provider.deleteSession(sessionId);
                provider.getCourseDetails(widget.courseId);
              },
              child: CustomText(title: "yes".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(builderContext).pop();
              },
              child: CustomText(title: "no".tr()),
            ),
          ],
        );
      },
    );
  }
}
