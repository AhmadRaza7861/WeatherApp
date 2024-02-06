import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:weather_app/models/weather_result.dart';
import 'package:weather_app/view_model/weather_vm/weather_viewmodel.dart';

import '../../network/open_weather_map_client.dart';

class WeatherViewModelImp implements WeatherViewModel
{
  @override
  Future<WeatherResult> getWeather(LocationData locationData) {
  return OpenWeatherMapClient().getWeather(
      locationData
  );
  }

  @override
  Future<ForecastResult> getForecast(LocationData locationData) {
    // TODO: implement getForecast
   return OpenWeatherMapClient().getForecast(locationData);
  }


}