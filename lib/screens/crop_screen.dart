import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/share_screen.dart';

import '../common/color_constants.dart';
import '../common/crop_editor_helper.dart';

class CropScreen extends StatefulWidget {
  CropScreen({Key? key,required this.imageData}) : super(key: key);
  static route(Uint8List imageData)=>MaterialPageRoute(builder: (context)=>CropScreen(imageData:imageData,));
  Uint8List imageData;
  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<
      ExtendedImageEditorState>();
  EditorCropLayerPainter? _cropLayerPainter;
  Uint8List? _croppedData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cropLayerPainter = const EditorCropLayerPainter();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorConstants.colorBg1,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon:Platform.isAndroid?Icon(Icons.arrow_back):Icon(Icons.arrow_back_ios),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: ()async{
            Uint8List? fileData = await cropImageDataWithNativeLibrary(
                state: editorKey.currentState!);
            setState(() {
              _croppedData = fileData;
            });
            Navigator.push(context,ShareScreen.route(_croppedData));
          }, icon: Icon(Icons.crop))
        ],
      ),
      body:Column(
        children: [
          Expanded(
              child:
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                child: ExtendedImage.memory(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  widget.imageData,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  alignment: Alignment.center,
                  enableLoadState: true,
                  cacheHeight: 200,
                  extendedImageEditorKey: editorKey,
                  initEditorConfigHandler: (
                      ExtendedImageState? state) {
                    return EditorConfig(
                        maxScale: 8.0,
                        cornerColor: Colors.red,
                        cropRectPadding: const EdgeInsets
                            .all(10.0),
                        hitTestSize: 20.0,
                        cropLayerPainter: _cropLayerPainter!,
                        initCropRectType: InitCropRectType
                            .imageRect,
                        cropAspectRatio:CropAspectRatios.custom,
                        editActionDetailsIsChanged: (qq) {
                        }
                      //_aspectRatio!.value,
                    );
                  },
                  cacheRawData: true,
                  clearMemoryCacheWhenDispose: true,
                ),
              )
          ),
        ],
      ) ,
    );
  }
}
