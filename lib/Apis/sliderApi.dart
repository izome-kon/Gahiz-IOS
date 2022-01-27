import 'package:denta_needs/Responses/Slider/slider_response.dart';
import 'package:denta_needs/app_config.dart';
import 'package:http/http.dart' as http;

class SliderApi {
  Future<SliderResponse> getSliders() async {
    final response = await http.get(Uri.parse("${AppConfig.BASE_URL}/sliders"));
    return sliderResponseFromJson(response.body);
  }
}
