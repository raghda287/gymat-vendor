import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/workout_model.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/home_screen/widgets/workout_item_widget.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/provider/workout_provider.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/workout_screen/widgets/workout_item_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/loading_indicator/loading_indicator_gym.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/text_styles/text_styles.dart';
import '../../../injection.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_svg/CustomSvgIcon.dart';
import '../add_workout_screen/add_workout_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  WorkoutProvider workoutProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      workoutProvider.initWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        title: 'Workouts'.tr(),
        elevation: 1,
        isMainBack: true,
        bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: provider.isLoading
                    ? const LoadingIndicatorGym()
                    : provider.workouts.isEmpty
                        ? Center(
                            child: CustomText(
                            title: 'No workouts to show...'.tr(),
                            fontColor: AppTheme.isDarkMode()
                                ? Colors.white
                                : Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ))
                        : GridView.builder(
                            itemCount: provider.workouts.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 4),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    NavigatorHandler.push(AddWorkoutScreen(workoutModel: provider.workouts[index],fromPage: 'workout',
                                    ));
                                  },
                                  onLongPress: () {
                                    showServiceActionSheet(provider.workouts[index], index);
                                  },
                                  child: WorkoutItemWidget2(
                                    workoutModel: provider.workouts[index],
                                  ));
                            }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: CustomButton(
                    title: 'Add workout'.tr(),
                    onTap: () {
                      NavigatorHandler.push(const AddWorkoutScreen(fromPage: 'workout',));
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  void showServiceActionSheet(WorkoutModel model, int index) {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
        context: context,
        builder: (context) {
          return SizedBox(
            width: Dimens.width,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      width: 54,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppTheme.isDarkMode()
                              ? greyColor.withOpacity(.2)
                              : greyColor.withOpacity(.5)),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'delete',
                      color:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Delete'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 300));
                      createDeleteAlertDialog(
                          Text.rich(TextSpan(
                              text: '${'Delete'.tr()} ',
                              style: AppTextStyles()
                                  .normalText(fontSize: 13)
                                  .textColorNormal(AppTheme.isDarkMode()
                                      ? greyColor
                                      : Colors.black),
                              children: [
                                TextSpan(
                                    text: model.trans_title ?? '',
                                    style: AppTextStyles()
                                        .normalText(fontSize: 17)
                                        .textColorBold(AppTheme.isDarkMode()
                                            ? Colors.white
                                            : Colors.black))
                              ])), () async {
                        NavigatorHandler.pop();
                        await Future.delayed(const Duration(milliseconds: 300));
                        workoutProvider.deleteWorkout(model);
                      }, () {
                        NavigatorHandler.pop();
                      });
                    },
                  ),
                  ListTile(
                    leading: CustomSvgIcon(
                      assetName: 'edit2',
                      width: 18,
                      height: 18,
                      color:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                    ),
                    title: CustomText(
                      title: 'Edit'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      await NavigatorHandler.pop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      NavigatorHandler.push(AddWorkoutScreen(
                        workoutModel: model,
                        fromPage: 'workout',
                      ));
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void createDeleteAlertDialog(
      Widget titleWidget, VoidCallback onDelete, VoidCallback onCancel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppTheme.isDarkMode() ? dark : Colors.white,
            contentPadding: const EdgeInsets.all(12),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                titleWidget,
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: onCancel,
                        child: CustomText(
                          title: 'Cancel'.tr(),
                          fontSize: 14,
                          fontColor: greyColor,
                        )),
                    const SizedBox(
                      width: 12,
                    ),
                    TextButton(
                        onPressed: onDelete,
                        child: CustomText(
                          title: 'Delete'.tr(),
                          fontSize: 14,
                          fontColor: Colors.red,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }
}
