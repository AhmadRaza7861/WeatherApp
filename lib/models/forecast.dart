import 'package:weather_app/models/weather_result.dart';

class ForecastResult
{
  List<ListResult>? list;

  ForecastResult({this.list});

  ForecastResult.fromJson(Map<String,dynamic>json)
  {
    if(json['list']!=null)
      {
        list=<ListResult>[];
        json['list'].forEach((v)
        {
          list!.add(ListResult.fromJson(v));
        });
      }
  }

  Map<String,dynamic>toJson()
  {
    var data=<String,dynamic>{};

    if(list!=null)
      {
        data['list']=list!.map((v) => v.toJson).toList();
      }
    return data;
  }
}


class ListResult
{
  int? dt;
  Main? main;
  ListResult({this.dt, this.main});

  ListResult.fromJson(Map<String,dynamic>json)
  {
    dt= json['dt'];
   main=json['main']!=null ? Main.fromJson(json['main']):null;
  }

  Map<String,dynamic> toJson()
  {
    var data=<String,dynamic>{};

    if(main !=null)
      {
        data['main']=main!.toJson();
      }
    return data;
  }

}