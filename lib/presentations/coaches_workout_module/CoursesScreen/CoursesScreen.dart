import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/course_response.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/CoursesScreen/AddCourseScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/CoursesScreen/CourseCardWidget.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/CoursesScreen/CourseDetailsScreen.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/coach_services_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CoursesScreenState();
  }
}

class CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    CoachServicesProvider provider = getIt();
    provider.getCourses();
  }

  @override
  void dispose() {
    super.dispose();
    CoachServicesProvider provider = getIt();
    provider.clearCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'courses'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<CoachServicesProvider>(
        builder: (context, provider, _) {
          return provider.courseResponse == null ||
                  provider.courseResponse!.data.isEmpty
              ? Stack(
                children: [
                  Center(
                    child: CustomText(
                      title: "No Courses Founded",
                      fontColor:
                      AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                  ),

                  PositionedDirectional(
                    bottom: 20,
                    start: 20,
                    end: 20,
                    child: CustomButton(
                      title: "Add Course".tr(),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return AddCourseScreen();
                            },
                          ),
                        ).then((value) {
                          provider.getCourses();
                        });
                      },
                    ),
                  ),
                ],
              )
              : Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: SizedBox(
                  width: Dimens.width,
                  height: Dimens.height,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            CourseData courseData =
                                provider.courseResponse?.data == null
                                    ? CourseData(
                                      price: 0,
                                      description: "",
                                      id: 0,
                                      title: "",
                                      image: "",
                                      isFree: false,
                                    )
                                    : provider.courseResponse!.data[index];
                            return InkWell(
                              child: CourseCardWidget(
                                width: Dimens.width,
                                courseData: courseData,
                                deleteCourse: () async {
                                  _showDeleteDialog(
                                    context,
                                    provider,
                                    courseData.id,
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CourseDetailsScreen(
                                        courseId: courseData.id,
                                      );
                                    },
                                  ),
                                );
                              },
                              onLongPress: () async {
                                _showDeleteDialog(
                                  context,
                                  provider,
                                  courseData.id,
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemCount:
                              provider.courseResponse?.data == null
                                  ? 0
                                  : provider.courseResponse!.data.length,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        title: "Add Course".tr(),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AddCourseScreen();
                              },
                            ),
                          ).then((value) {
                            provider.getCourses();
                          });
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

  void _showDeleteDialog(
    BuildContext context,
    CoachServicesProvider provider,
    int courseId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CustomText(title: "do you want to delete this course".tr()),
          actions: [
            TextButton(
              onPressed: () async {
                await provider.deleteCourse(courseId);
                provider.getCourses();
                Navigator.pop(context);
              },
              child: CustomText(title: "yes".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(title: "no".tr()),
            ),
          ],
        );
      },
    );
  }
}
