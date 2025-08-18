import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/ask_question_module/ask_answer_question_screen.dart';
import 'package:gymatvendor/presentations/ask_question_module/provider/question_provider.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';
import 'package:gymatvendor/presentations/widgets/custom_text_form_area/custom_text_form_area.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';

import '../../injection.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showToolBar: true,
          showBackArrow: true,
          isMainBack: true,
          title: 'Ask a question'.tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
               Expanded(child:Column(
                 crossAxisAlignment: CrossAxisAlignment.start,

                 children: [
                   const SizedBox(height: 12,),
                   CustomText(title: 'Ask us'.tr(), fontColor: greyColor,),
                  const SizedBox(height: 12,),
                  CustomTextFormFieldArea(controller: _controller,height: 110,)
                ],
              )),
              const SizedBox(height: 12,),
              CustomButton(title: 'Submit'.tr(), onTap: (){
                String question = _controller.text.trim();
                if(question.isNotEmpty){
                  QuestionProvider provider = getIt();
                  provider.addQuestion(question);
                  NavigatorHandler.push(const AskAnswerScreen());
                }else{
                  CustomScaffoldMessanger.showToast(title: 'Field required'.tr(),gravity: ToastGravity.TOP);
                }
              }),
              const SizedBox(height: 12,),


            ],
          ),
        ));
  }
}
