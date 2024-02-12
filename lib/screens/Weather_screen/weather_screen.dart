import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:screenshot/screenshot.dart';
import 'package:weather_app/common/color_constants.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather_result.dart';
import 'package:weather_app/screens/Weather_screen/widgets/fore_cast_widget.dart';
import 'package:weather_app/screens/Weather_screen/widgets/info_widget.dart';
import 'package:weather_app/screens/Weather_screen/widgets/weather_title_widget.dart';
import 'package:weather_app/screens/crop_screen.dart';
import 'package:weather_app/state/state.dart';
import 'package:weather_app/utils/utils.dart';
import 'package:weather_app/view_model/weather_vm/weather_viewmodel.dart';
import 'package:weather_app/view_model/weather_vm/weather_viewmodel_imp.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.title});
  final String title;
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final controller=Get.put(MyStateController());
  var location=Location();
  late StreamSubscription listener;
  late PermissionStatus permissionStatus;
  final WeatherViewModel viewModel=WeatherViewModelImp();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp)async {
      await  enableLocationListener();
    });

  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Obx(()=>Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        tileMode: TileMode.clamp,
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorConstants.colorBg1,
                          ColorConstants.colorBg2
                        ]
                    )
                ),
                child: controller.locationData.value.latitude!=null ?
                FutureBuilder(future: viewModel.getWeather(controller.locationData.value),
                    builder: (context,snapshot)
                    {
                      if(snapshot.connectionState==ConnectionState.waiting)
                      {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      else if(snapshot.hasError)
                      {
                        return Center(child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.white),),);
                      }
                      else if(!snapshot.hasData)
                      {
                        return Center(child:Text('No Data',style: TextStyle(color: Colors.white),) ,);
                      }
                      else
                      {
                        var data=snapshot.data as WeatherResult;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Screenshot(
                              controller:controller.screenshotController,
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height/55,),
                                  WeatherTileWidget(
                                      context:context,
                                      title:(data.name !=null && data.name!.isNotEmpty)?
                                      data.name:'${data.coord!.lat}/${data.coord!.lon}',
                                      titleFontSize:30,
                                      subTitle:DateFormat('dd-MMM-yyy').format(DateTime.fromMicrosecondsSinceEpoch((data.dt?? 0)*1000))
                                  ),
                                  Center(
                                    child: CachedNetworkImage(
                                      imageUrl: buildIcon(data.weather?[0].icon??''),
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder: (context,url,downloadProgress)=>const CircularProgressIndicator(),
                                      errorWidget: (context,url,err)=>const Icon(Icons.image,color: Colors.white,),
                                    ),
                                  ),
                                  WeatherTileWidget(
                                      context:context,
                                      title:'${data.main!.temp}°C',
                                      titleFontSize:60,
                                      subTitle:'${data.weather![0].description}'),
                                  const SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.width/8),
                                      InfoWidget(
                                        icon: FontAwesomeIcons.wind,
                                        text: '${data.wind!.speed}',
                                      ),
                                      InfoWidget(
                                        icon: FontAwesomeIcons.cloud,
                                        text: '${data.clouds!.all}',
                                      ),
                                      InfoWidget(
                                        icon: FontAwesomeIcons.snowflake,
                                        text: data.snow!=null?'${data.snow!.d1h}':'0',
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width/8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(onPressed: (){
                                controller.CaptureScreenShoot(context);
                              }, child: Text("ScreenShot")),
                            ),
                            Expanded(child: FutureBuilder(
                              future: viewModel.getForecast(controller.locationData.value),
                              builder: (context,snapshot)
                              {
                                if(snapshot.connectionState==ConnectionState.waiting)
                                {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                else if(snapshot.hasError)
                                {
                                  return Center(child: Text(snapshot.error.toString(),style: const TextStyle(color: Colors.white),),);
                                }
                                else if(!snapshot.hasData)
                                {
                                  return Center(child:Text('No Data',style: TextStyle(color: Colors.white),) ,);
                                }
                                else {
                                  var data=snapshot.data as ForecastResult;
                                  return
                                    ListView.builder(
                                        itemCount: data.list!.length??0,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index)
                                        {
                                          var item=data.list![index];
                                          return ForeCastTitleWidget(
                                              temp: "${item.main!.temp}", time:DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch((item.dt??0)*1000)));
                                        });
                                }
                              },
                            )
                            )
                          ],
                        );
                      }

                    })
                    :
                const Center(child: Text('Waiting....',style: const TextStyle(color: Colors.white),),)
            ),)
        )
    );
  }

  Future<void> enableLocationListener()async {
    controller.isEnableLocation.value=await location.serviceEnabled();
    if(!controller.isEnableLocation.value)
    {
      controller.isEnableLocation.value=await  location.requestService();
      if(!controller.isEnableLocation.value)
      {
        return;
      }
    }
    permissionStatus=await location.hasPermission();
    if(permissionStatus==PermissionStatus.denied)
    {
      permissionStatus=await location.requestPermission();
      if(permissionStatus!=PermissionStatus.granted)
      {
        return;
      }
    }
    controller.locationData.value=await location.getLocation();
    listener=location.onLocationChanged.listen((event) {

    });
  }
}