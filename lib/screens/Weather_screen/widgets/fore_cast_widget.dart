import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ForeCastTitleWidget extends StatelessWidget {
  String? temp;
  String? time;

  ForeCastTitleWidget({this.temp, this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                temp ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              CachedNetworkImage(
                imageUrl: 'http://openWeathermap.org/img/wn/11d@4x.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context,url,downloadProgress)=>const CircularProgressIndicator(),
                errorWidget: (context,url,err)=>const Icon(Icons.image,color: Colors.white,),
              ),
              Text(
                time ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
