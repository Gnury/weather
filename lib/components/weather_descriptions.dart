
import 'enum_value.dart';

enum Description {
  Sunny,
  Rainy,
  Storm,
  Cloudy,
  Clear_Sky,
  Few_Cloud,
}

final descriptionValues = EnumValues({
  "broken clouds": Description.Sunny,
  "light rain": Description.Rainy,
  "moderate rain": Description.Storm,
  "overcast clouds": Description.Cloudy,
  "clear sky": Description.Clear_Sky,
  "few clouds": Description.Few_Cloud,
});