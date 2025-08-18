import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/text_styles/text_styles.dart';
import 'package:gymatvendor/presentations/map_search_screen/provider/MapProvider.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:provider/provider.dart';

class MapSearchWidget extends StatefulWidget {
  final double radius;
  final double elevation;
  const MapSearchWidget({super.key,required this.radius,required this.elevation});

  @override
  State<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  late final TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _controller = TextEditingController();
    //provider.locationModel?.address
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context,provider,_){
      _controller.text = !provider.isLoadingLocation?provider.locationModel!=null?provider.locationModel!.address??'':'':'';
      return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        surfaceTintColor: Colors.transparent,
        color: AppTheme.isDarkMode()?Colors.black:Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const CustomSvgIcon(assetName: 'search',color: greyColor,width: 18,height: 18,),
              const SizedBox(width: 24,),
              Expanded(child: TextFormField(

                controller: _controller,
                keyboardType: TextInputType.text,
                textAlignVertical: TextAlignVertical.center,
                onFieldSubmitted: (value){
                  provider.searchWithText(value);
                },
                cursorColor: AppTheme.isDarkMode()?Colors.white:Colors.black,
                textInputAction: TextInputAction.search,
                style: AppTextStyles().normalText(fontSize: 15).textColorNormal(AppTheme.isDarkMode()?Colors.white:Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: provider.isLoadingLocation?"Getting location...".tr():'',
                    hintStyle: AppTextStyles().normalText(fontSize: 14).textColorNormal(greyColor)
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
