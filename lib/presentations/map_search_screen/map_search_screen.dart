import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/constants/constants.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/core/navigator/navigator.dart';
import 'package:gymatvendor/presentations/map_search_screen/provider/MapProvider.dart';
import 'package:gymatvendor/presentations/map_search_screen/widgets/map_search_widget.dart';
import 'package:gymatvendor/presentations/widgets/custom_button/custom_button.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';
import 'package:provider/provider.dart';

import '../../injection.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
   final Completer<GoogleMapController> _completerControler = Completer<GoogleMapController>();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MapProvider mapProvider = getIt();
    mapProvider.init();
  }

  @override
  Widget build(BuildContext context) {
     String lang = context.locale.languageCode;
     return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        showToolBar: true,
        showBackArrow: true,
        isMainBack: true,
        title: 'Select location on map'.tr(),
      ),
      body: Consumer<MapProvider>(builder: (context,provider,_){
        return Stack(
          children:[
            GoogleMap(
              initialCameraPosition: provider.initialCameraPosition,
              zoomControlsEnabled: false,
              onMapCreated: (controler) async{
                await controler.setMapStyle(AppTheme.isDarkMode()?darkMap:normaMap);
                 _completerControler.complete(controler);
                provider.getLocation(_completerControler,lang);

              },
              onCameraMove: (position){
                provider.searchWithLatLng(position.target.latitude, position.target.longitude, lang);
              },
            ),
            if(!provider.isLoadingCurrentLocation)Padding(
              padding: EdgeInsets.only(bottom: Dimens.height*.045),
              child:  Center(child: CustomSvgIcon(assetName: 'pin1',color: AppTheme.isDarkMode()?Colors.white:mainColor,width: 36,height: 36,)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0,right: 12.0,top: 12.0),
              child: MapSearchWidget(radius: 8, elevation: 1,),
            ),
            (provider.isLoadingLocation||provider.isLoadingCurrentLocation)?const SizedBox():provider.locationModel!=null?Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: CustomButton(title: 'Confirm'.tr(), onTap: (){
                NavigatorHandler.pop(provider.locationModel);
              }),
            ):const SizedBox(),
          ] ,
        );

      },),
    );
  }


}
