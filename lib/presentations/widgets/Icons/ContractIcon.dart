import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/injection.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:gymatvendor/presentations/widgets/dialogs/scaffold_messanger.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../custom_button/custom_button.dart';

class ContractIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      _showChoicesDialog(context);
    }, icon: Icon(Icons.file_present,
      size: 24,color: AppTheme.isDarkMode()?Colors.white:greyColor,));
  }

  void _showChoicesDialog(BuildContext context) {
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              CustomButton(title: "UploadContract".tr(), onTap: (){
                Navigator.pop(context);
                _pickContract();
              }),
              CustomButton(title: "DownloadContract".tr(), onTap: (){
                Navigator.pop(context);
                ProfileProvider profileProvider = getIt();
                profileProvider.downloadContract();
              }),
            ],
          ),
        ),

      );
    }).then((_){
      ProfileProvider profileProvider = getIt();
      profileProvider.clearContractUrl();
    });
  }

  void _pickContract()async{
    ProfileProvider profileProvider = getIt();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf']
    );
    if(result!=null){
      profileProvider.uploadContract(File(result!.files.single.path!));
    }else{
      CustomScaffoldMessanger.showScaffoledMessanger(title: "NoFileSelected".tr());
    }
  }
}