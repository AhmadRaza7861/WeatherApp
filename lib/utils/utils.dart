String buildIcon(String icon,{bool isBigSize=true})
{
  if(isBigSize)
    {
      return 'http://openWeathermap.org/img/wn/$icon@4x.png';
    }
  else
    {
      return 'http://openWeathermap.org/img/wn/$icon.png';
    }
}