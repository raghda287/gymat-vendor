import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gymatvendor/core/app_colors/app_colors.dart';
import 'package:gymatvendor/core/app_theme/theme.dart';
import 'package:gymatvendor/core/dimens/dimens.dart';
import 'package:gymatvendor/data/models/department_model.dart';
import 'package:gymatvendor/data/models/user_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_text/custom_text.dart';

class ShopCategoryWidget extends StatefulWidget {
  final DepartmentModel? model;
  final int? defaultIndex;
  final ValueChanged<int> onIndexChanged;
  final List<ShopCategory> list;

  const ShopCategoryWidget(
      {super.key,
      this.model,
      required this.defaultIndex,
      required this.onIndexChanged,
      required this.list});

  @override
  State<ShopCategoryWidget> createState() => _ShopCategoryWidgetState();
}

class _ShopCategoryWidgetState extends State<ShopCategoryWidget> {
  late int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultIndex == null) {
      index = 0;
    } else {
      index = widget.defaultIndex!;
    }
    return Center(
      child: SizedBox(
          height: 42,
          child: ListView.builder(
              itemCount: widget.list.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    this.index = index;
                    setState(() {});
                    widget.onIndexChanged(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: index == this.index
                            ? mainColor
                            : AppTheme.isDarkMode()
                                ? inputBgDark
                                : inputBg,
                        borderRadius: BorderRadius.circular(4)),
                    child: CustomText(
                      title: widget.list[index].category?.trans_title != null
                          ? widget.list[index].category!.trans_title!.startsWith('trans.')
                              ? widget.list[index].category?.title
                              : widget.list[index].category?.trans_title
                          : widget.list[index].category?.title ?? '',
                      fontSize: 11,
                      fontColor: this.index == index
                          ? Colors.white
                          : AppTheme.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                );
              })),
    );
  }
}
