import 'package:flutter/material.dart';
import 'package:gymatvendor/data/models/certificate_file_model.dart';
import 'package:gymatvendor/presentations/widgets/custom_rounded_image/custom_rounded_image.dart';
import 'package:gymatvendor/presentations/widgets/custom_svg/CustomSvgIcon.dart';

class ImageCertificateWidget extends StatelessWidget {
  final CertificateFileModel model;
  final int index;
  final Function onDelete;

  const ImageCertificateWidget({super.key, required this.model, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {

    return model.extension != 'pdf'
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CustomRoundedImage(
                  width: 64,
                  height: 64,
                  url: model.filePath.startsWith('http')?model.filePath:'fileimage:${model.filePath}',
                  radius: 8,
                  elevation: 1,
                  boxFit: BoxFit.cover,
                ),
              ),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                  onDelete(index);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 6,right: 6,top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.5),shape: BoxShape.circle),
                  child: const Icon(Icons.close,color: Colors.black,size: 16,),
                ),
              )

            ],
          )
        : Stack(
            children: [
              Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Card(
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 1,
                    margin: const EdgeInsets.all(2),
                    child: Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(16),
                      child: const CustomSvgIcon(
                        assetName: 'pdf2',
                      ),
                    ),
                  )),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: (){
                  onDelete(index);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 6,right: 6,top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.5),shape: BoxShape.circle),
                  child: const Icon(Icons.close,color: Colors.black,size: 16,),
                ),
              )

            ],
          );
  }
}
