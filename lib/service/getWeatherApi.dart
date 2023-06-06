import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi{
  static String apiKey = "820878fa152ed92767a4a4774a6c4aa6";
  static String baseUrl = "https://api.openweathermap.org/geo/1.0/direct?";
  static String weatherUrl = "https://api.openweathermap.org/data/2.5/onecall?";
  static Future<Map<String, dynamic>> getWeatherData() async{
    try{
      String locationApi = baseUrl+"q=chennai&appid=$apiKey";
      http.Client client = http.Client();
      Map<String, dynamic>? responseBody;
      final response = await client.get(Uri.parse(locationApi));
      if (response.statusCode == 200) {
        List<dynamic>? coordinatesBody = json.decode(response.body);
        responseBody = await getUsingLatLong(coordinatesBody![0]['lat'].toString(),coordinatesBody![0]['lon'].toString()) ;
        return responseBody;
      }
      return responseBody!;
    }
    catch(ex){
      throw Exception('Response error: ${ex.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getUsingLatLong(String lat, String lon) async{
    String weatherApi = weatherUrl+"lat=$lat&lon=-$lon&cnt=8&appid=$apiKey";
    try{
      http.Client client = http.Client();
      Map<String, dynamic>? responseBody;
      final response = await client.get(Uri.parse(weatherApi));
      if (response.statusCode == 200) {
        responseBody = json.decode(response.body);
        return responseBody!;
      }
      return responseBody!;
    }
    catch(ex){
      throw Exception('Response Weather error: ${ex.toString()}');
    }
  }

}