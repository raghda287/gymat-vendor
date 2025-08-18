import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/notificationModel.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/notification_screen/provider/notifications_provider.dart';
import 'package:gymatvendor/presentations/notification_screen/widgets/notification_item.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors/app_colors.dart';
import '../../core/app_theme/theme.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_text/custom_text.dart';
import '../widgets/loading_indicator/loading_indicator.dart';
import '../widgets/loading_indicator/loading_indicator_gym.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsProvider notificationsProvider = getIt();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationsProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notificationsProvider.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Notifications'.tr(),
          elevation: 1,
          bgColor: AppTheme.isDarkMode() ? dark : Colors.white,
        ),
        body: Consumer<NotificationsProvider>(builder: (context, provider, _) {
          return provider.isLoading
              ? const LoadingIndicatorGym()
              : provider.notification.isEmpty
                  ? Center(
                      child: CustomText(
                      title: 'No Notification to show'.tr(),
                      fontColor:
                          AppTheme.isDarkMode() ? Colors.white : Colors.black,
                      fontSize: 15,
                    ))
                  : NotificationListener<ScrollNotification>(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: provider.notification.length,
                          itemBuilder: (context, index) {
                            NotificationModel? model = provider.notification[index];
                            if (model != null) {
                              return NotificationItem(
                                model: model,
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                child: LoadingIndicator(),
                              );
                            }
                          }),
                      onNotification: (notificiationScroll) {
                        if (!provider.isLoadingMore && provider.notification.length > 39 && notificiationScroll.metrics.pixels == notificiationScroll.metrics.maxScrollExtent) {
                          provider.loadMoreNotification();
                        }
                        return false;
                      },
                    );
        }));
  }
}
