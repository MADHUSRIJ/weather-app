import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  final Map<String,dynamic> currentWeather;
  const Home({Key? key, required this.currentWeather}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    var temperature =  widget.currentWeather['temp'] - 273;
    double roundedTemperature = temperature.floorToDouble();
    String formattedTemperature = roundedTemperature.toStringAsFixed(2);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Report",
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
                               image: NetworkImage("https://openweathermap.org/img/wn/${widget.currentWeather['weather'][0]['icon']}@2x.png"),
                               fit: BoxFit.fill
                           )
                       ),
                     ),
                   ),
                    Text(
                      widget.currentWeather['weather'][0]['description'],
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
                    climateData("Pressure","${widget.currentWeather['pressure']} hPa", "https://cdn-icons-png.flaticon.com/512/2446/2446147.png"),
                    climateData("Humidity","${widget.currentWeather['humidity']} %", "https://cdn-icons-png.flaticon.com/512/6244/6244299.png"),
                    climateData("Wind Speed","${widget.currentWeather['wind_speed']} m/s", "https://cdn-icons-png.flaticon.com/512/3579/3579552.png"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
