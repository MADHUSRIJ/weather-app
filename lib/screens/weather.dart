import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/service/get_user_location.dart';
import 'package:weather_app/service/get_weather_api.dart';

class Weather extends StatefulWidget {
  final Map<String, dynamic> currentWeather;
  const Weather({Key? key, required this.currentWeather}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  List<dynamic>? forecastData;

  bool fetchedData = false;

  Future<void> fetchForecastData() async {
    try {
      Map<String, dynamic> data = await WeatherApi.getForecastUsingLatLong(GetUserLocation.currentPosition!.latitude.toString(), GetUserLocation.currentPosition!.longitude.toString());
      setState(() {
        forecastData = data['list'];
        fetchedData = true;
      });
    } catch (ex) {
      throw Exception('Home error: ${ex.toString()}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchForecastData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);

    var temperature = widget.currentWeather['main']['temp'] - 273;
    double roundedTemperature = temperature.floorToDouble();
    String formattedTemperature = roundedTemperature.toStringAsFixed(2);

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Container(
                height: 160,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                    color: const Color(0xff395B64),
                    borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://openweathermap.org/img/wn/${widget.currentWeather['weather'][0]['icon']}@2x.png"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.currentWeather['weather'][0]['description'],
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$formattedTemperature °",
                            style: GoogleFonts.poppins(
                                fontSize: 32, color: Colors.amber.shade600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Weather Forecast",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ),
              fetchedData ? Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    DateTime forecastDate = DateTime.parse(forecastData![index+1]['dt_txt']);
                    String foreCastFormattedDate = DateFormat('hh:mm aa').format(forecastDate);

                    var forecastTemperature = forecastData![index+1]['main']['temp'] - 273;
                    double forecastRoundedTemperature = forecastTemperature.floorToDouble();
                    String forecastFormattedTemperature = forecastRoundedTemperature.toStringAsFixed(2);


                    return Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Text(
                                      foreCastFormattedDate,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.white60),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      height: 250,
                                      width: 125,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://openweathermap.org/img/wn/${forecastData![index+1]['weather'][0]['icon']}@2x.png"),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      forecastData![index+1]['weather'][0]
                                          ['description'],
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    "$forecastFormattedTemperature °",
                                    style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        color: Colors.amber.shade600),
                                  )),
                                ],
                              )),
                          Expanded(
                              child: Column(
                            children: [
                              climateData(
                                  "Pressure",
                                  "${forecastData![index+1]['main']['pressure']} hPa",
                                  "https://cdn-icons-png.flaticon.com/512/2446/2446147.png"),
                              climateData(
                                  "Humidity",
                                  "${forecastData![index+1]['main']['humidity']} %",
                                  "https://cdn-icons-png.flaticon.com/512/6244/6244299.png"),
                              climateData(
                                  "Wind Speed",
                                  "${forecastData![index+1]['wind']['speed']} m/s",
                                  "https://cdn-icons-png.flaticon.com/512/3579/3579552.png"),
                            ],
                          )),
                        ],
                      ),
                    );
                  },
                  itemCount: forecastData!.length-1,
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    ));
  }

  Expanded climateData(String attribute, String value, String image) {
    return Expanded(
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill)),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
