import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ask_question_module/add_question_screen.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_app_bar/custom_app_bar.dart';
import 'provider/question_provider.dart';
import 'widgets/ask_answer_widget.dart';
import 'widgets/ask_question_widget.dart';
import 'widgets/no_questions_widget.dart';

class AskAnswerScreen extends StatefulWidget {
  const AskAnswerScreen({super.key});

  @override
  State<AskAnswerScreen> createState() => _AskAnswerScreenState();
}

class _AskAnswerScreenState extends State<AskAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Ask a question'.tr(),
        ),
        body: Consumer<QuestionProvider>(
          builder: (context, provider, _) {
            return  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12,),
                  CustomText(title: 'Question'.tr(),fontColor: greyColor,),
                  const SizedBox(height: 12,),
                  AskAnswerWidget(title:'TEXT go here',bg: AppTheme.isDarkMode()?inputBgDark:inputBg, fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,),
                  const SizedBox(height: 24,),
                  CustomText(title: 'Answer'.tr(),fontColor: greyColor,),
                  const SizedBox(height: 12,),
                  const AskAnswerWidget(title:'TEXT go here',bg: mainColor, fontColor: Colors.white,)

                ],
              ),
            );
          },
        ));

  }
}
