import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

import '../../../core/app_colors/app_colors.dart';

class DownScrollButton extends StatefulWidget {
  final bool show;
  final VoidCallback onPressed;
  const DownScrollButton({super.key, required this.show, required this.onPressed});

  @override
  State<DownScrollButton> createState() => _DownScrollButtonState();
}

class _DownScrollButtonState extends State<DownScrollButton> {
  double width = 24;
  double height = 24;

  double _changableWidth = 0;
  double _changableHeight = 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _changableWidth = widget.show?width:0;
    _changableHeight= widget.show?height:0;


  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: AppTheme.isDarkMode()?msgLeftDarkColor:Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
        elevation: 1,
        child: AnimatedContainer(
          width: _changableWidth,
          height: _changableHeight,
          padding: const EdgeInsets.all(5),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,

          child:  CustomSvgIcon(assetName: 'double_down_arrow',color: AppTheme.isDarkMode()?Colors.white:Colors.black,width: 20,height: 20,),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DownScrollButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.show != widget.show){
      _changableWidth = widget.show?width:0;
      _changableHeight= widget.show?height:0;
      if(mounted){
        setState(() {

        });
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
}
