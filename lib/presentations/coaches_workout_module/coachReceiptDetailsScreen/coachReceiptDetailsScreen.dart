import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coachReceiptDetailsScreen/widgets/coach_receipt_details.dart';
import 'package:gymatvendor/presentations/coaches_workout_module/coachReceiptDetailsScreen/widgets/coach_receipt_details_print.dart';
import 'package:gymatvendor/presentations/gym_module/gymReceiptDetailsScreen/widgets/receipt_details.dart';
import 'package:gymatvendor/presentations/gym_module/gymReceiptDetailsScreen/widgets/receipt_details_print.dart';
import 'package:gymatvendor/presentations/gym_module/gymReceiptDetailsScreen/widgets/service_order_item.dart';
import 'package:path_provider/path_provider.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/number_format/numberFormat.dart';
import '../../../data/models/coachOrderDetailsModel.dart';
import '../../../data/models/gymOrderDetailsModel.dart';
import '../../../main.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_avatar/custom_avatar.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_text/custom_text.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class CoachReceiptDetailsScreen extends StatefulWidget {
  final CoachOrderDetailsModel model;
  const CoachReceiptDetailsScreen({super.key, required this.model});

  @override
  State<CoachReceiptDetailsScreen> createState() => _CoachReceiptDetailsScreenState();
}

class _CoachReceiptDetailsScreenState extends State<CoachReceiptDetailsScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:  CustomAppBar(showToolBar: true,showBackArrow: true,isMainBack: true,title: 'E-Receipt'.tr(),elevation: 1,bgColor: AppTheme.isDarkMode()?dark:Colors.white,),
        body:Column(
          children: [
            Expanded(
              child: Stack(children: [
                CoachReciptDetailsPrint(model: widget.model,screenshotController: screenshotController,),
                CoachReciptDetails(model: widget.model)
              ],),
            ),
            const SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
              child: CustomButton(title: 'Download receipt'.tr(),fontSize: 12,fontColor: Colors.white, onTap: () async{
                ProgressDialog dialog = createProgressDialog(context: navigatorKey.currentContext!, msg: 'Downloading ...'.tr());
                await dialog.show();
                var uint8list = await screenshotController.capture();
                if (uint8list != null) {
                  Directory? tempDir = await getExternalStorageDirectory();
                  if (tempDir != null) {
                    String filePath = "${tempDir.path}/bill_${DateTime.now().millisecond}.jpg";
                    File file = File(filePath);
                    await file.writeAsBytes(uint8list); // Writing dummy JPEG data

                    final params = SaveFileDialogParams(
                      sourceFilePath: filePath,
                    );
                    await FlutterFileDialog.saveFile(params: params);
                    CustomScaffoldMessanger.showToast(
                      title: "Downloaded success!".tr(),
                    );
                  }

                }
                await dialog.hide();

              }),
            )
          ],
        )
    );

  }
}
