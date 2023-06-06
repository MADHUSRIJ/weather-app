import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/service/get_weather_api.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = TextEditingController();

  Map<String, dynamic>? weatherData;
  bool fetchedData = false;

  String formattedTemperature = "";

  Future<void> fetchWeatherData() async {
    try {
      Map<String, dynamic> data = await WeatherApi.getWeatherData(searchController.text);
      setState(() {
        weatherData = data;
        fetchedData = true;
        var temperature =  weatherData!['main']['temp'] - 273;
        double roundedTemperature = temperature.floorToDouble();
        formattedTemperature = roundedTemperature.toStringAsFixed(2);
      });
    } catch (ex) {
      throw Exception('Search error: ${ex.toString()}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1,color: Colors.grey.shade600)
                ),
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: searchController,
                  cursorColor: Colors.grey,
                  onFieldSubmitted: (value){
                    if(value!=""){
                      fetchWeatherData();
                    }
                    else{
                      setState(() {
                        fetchedData = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    suffixIcon: Icon(Icons.search,color: Color(0xffA5C9CA),)
                  ),
                ),
              ),
              fetchedData ? Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Report - ${weatherData!['name']}",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      height: 375,
                      margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(24)),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Color(0xffA5C9CA),
                            child:  Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage("https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png"),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                          Text(
                            weatherData!['weather'][0]['description'],
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$formattedTemperature °",
                            style: GoogleFonts.poppins(
                                fontSize: 40, color: Colors.amber.shade600),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 120,
                      margin: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          climateData("Pressure","${weatherData!['main']['pressure']} hPa", "https://cdn-icons-png.flaticon.com/512/2446/2446147.png"),
                          climateData("Humidity","${weatherData!['main']['humidity']} %", "https://cdn-icons-png.flaticon.com/512/6244/6244299.png"),
                          climateData("Wind Speed","${weatherData!['wind']['speed']} m/s", "https://cdn-icons-png.flaticon.com/512/3579/3579552.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      )
    ));
  }

  Expanded climateData(String attribute, String value, String image) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            color: Colors.white12, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill
                  )
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              attribute,
              style: GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

}

