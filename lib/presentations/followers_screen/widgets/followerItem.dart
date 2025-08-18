import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/data/models/followerModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/main.dart';
import 'package:gymatvendor/presentations/followers_screen/provider/followers_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_avatar/custom_avatar.dart';
import 'package:gymatvendor/presentations/widgets/custom_bordered_container/custom_bordered_container.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

import '../../chat_module/provider/chat_provider.dart';

class FollowerItem extends StatelessWidget {
  final FollowerModel model;
  final int index;

  const FollowerItem({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          CustomAvatar(
            radius: 54,
            url: model.user?.photo,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: CustomText(
            title: model.user?.name ?? '',
            fontColor: AppTheme.isDarkMode() ? Colors.white : Colors.black,
            fontSize: 16,
            maxLines: 1,
          )),
          const SizedBox(
            width: 12,
          ),
          InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                createDeleteAlert(model, index);
              },
              child: CustomBorderedContainer(
                width: 70,
                borderRadius: 50,
                height: 36,
                padding: 0,

                borderColor: mainColor,
                child: Center(
                    child: CustomText(
                        title: 'Remove'.tr(),
                        fontSize: 12,
                        fontColor: mainColor)),
              )),
          const SizedBox(
            width: 12,
          ),
          InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              ChatProvider chatProvider = getIt();
              chatProvider.createChatRoom(model.user!.id!, model.user!.name, model.user!.photo, null);
            },

            child: Container(
              alignment: Alignment.center,
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color:
                      AppTheme.isDarkMode() ? dark : mainColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24)),
              child: const CustomSvgIcon(
                assetName: 'chat',
                width: 16,
                height: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  void createDeleteAlert(FollowerModel model, int index) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: 'UnFollow'.tr(),
                      fontColor: AppTheme.isDarkMode() ? white : black,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                        child: CustomText(
                      title: model.user?.name ?? '',
                      fontColor: mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      maxLines: 1,
                    )),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomText(
                      title: '?'.tr(),
                      fontColor: AppTheme.isDarkMode() ? white : black,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () async {
                    await NavigatorHandler.pop();
                    await Future.delayed(const Duration(milliseconds: 200));
                    FollowersProvider provider = getIt();
                    provider.deleteFollower(model.user?.id, index);
                  },
                  child: CustomText(
                    title: 'Delete'.tr(),
                    fontSize: 14,
                    fontColor: Colors.red,
                  )),
              InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () async {
                    await NavigatorHandler.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      title: 'Cancel'.tr(),
                      fontSize: 14,
                      fontColor: AppTheme.isDarkMode()
                          ? Colors.white
                          : greyColor.withOpacity(.7),
                    ),
                  ))
            ],
          );
        });
  }
}
