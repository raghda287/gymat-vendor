import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_theme/theme.dart';
import '../../../core/navigator/navigator.dart';
import '../custom_svg/CustomSvgIcon.dart';
import '../custom_text/custom_text.dart';
import '../custom_text_form/custom_text_form.dart';

class PhoneCodeList extends StatefulWidget {
  final ValueChanged<CountryCode?> onSelected;
  const PhoneCodeList({super.key, required this.onSelected});

  @override
  State<PhoneCodeList> createState() => _PhoneCodeListState();
}

class _PhoneCodeListState extends State<PhoneCodeList> {
  late List<CountryCode> mainList;
  late List<CountryCode> list;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     mainList = const CountryCodePicker().countryList.map((e) => CountryCode.fromJson(e)).toList();
    mainList.sort((a,b)=>a.name!.compareTo(b.name!));

    list = List.from(mainList);



  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(title: 'Country code'.tr(),fontSize: 16,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontWeight: FontWeight.bold,),
            IconButton(onPressed: (){
              NavigatorHandler.pop();
            }, icon: CustomSvgIcon(assetName: 'close2',color: AppTheme.isDarkMode()?Colors.white:Colors.black,)),
          ],
        ),
        Divider(color: greyColor.withOpacity(.1),),
        const SizedBox(height: 8,),

        Container(
            decoration: BoxDecoration(border: Border.all(color: greyColor.withOpacity(.1)),borderRadius: BorderRadius.circular(4)),
            child: CustomTextFormField(controller: searchController,bgColor: Colors.transparent,borderRaduis: 4,onValueChange: (value){
              list = mainList.where((element) => element.name!.contains(value)||element.dialCode!.contains(value)).toList();
              setState(() {});

            },prefix: Icon(Icons.search,color: AppTheme.isDarkMode()?Colors.white:Colors.black,size: 20,),)),
        const SizedBox(height: 8,),
        Expanded(child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context,index){
              CountryCode code = list[index];
              return InkWell(
                onTap: (){
                  widget.onSelected(list[index]);
                  NavigatorHandler.pop();
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Row(children: [
                          Image.asset(code.flagUri!,package: 'country_code_picker',width: 32,height: 24,),
                          const SizedBox(width: 12,),
                          Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: CustomText(title: code.name,fontColor: AppTheme.isDarkMode()?Colors.white:Colors.black,fontSize: 13,maxLines: 1,))
                        ],)),

                        CustomText(title: code.dialCode,fontColor: AppTheme.isDarkMode()?Colors.white.withOpacity(.5):greyColor.withOpacity(.4),fontSize: 14,fontWeight: FontWeight.bold,)

                      ],
                    ),
                    const SizedBox(height: 12,)
                  ],
                ),
              );
            }))


      ],),
    );
  }
}
