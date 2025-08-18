import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ask_question_module/add_question_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_app_bar/custom_app_bar.dart';
import 'provider/question_provider.dart';
import 'widgets/ask_question_widget.dart';
import 'widgets/no_questions_widget.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
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
            return  Column(
              children: [
                const Expanded(child:NoQuestionsWidget()),
                const SizedBox(height: 8,),
                AskQuestionWidget(onTap: () {
                  NavigatorHandler.push(const AddQuestionScreen());
                },),
                const SizedBox(height: 12,),

              ],
            );
          },
        ));

  }
}
