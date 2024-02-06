import 'package:location/location.dart';

import '../../models/forecast.dart';
import '../../models/weather_result.dart';

abstract class WeatherViewModel
{
  Future<WeatherResult> getWeather(LocationData locationData);
  Future<ForecastResult> getForecast(LocationData locationData);
}