import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_app/screens/home.dart';
import 'package:weather_app/screens/profile.dart';
import 'package:weather_app/screens/search.dart';
import 'package:weather_app/screens/weather.dart';
import 'package:weather_app/service/get_user_location.dart';

import 'package:weather_app/service/get_weather_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String, dynamic>? weatherData;

  List<Widget>? _screens;

  int _selectedIndex = 0;


  Future<void> fetchWeatherData() async {
    try {
      Map<String, dynamic> data = await WeatherApi.getUsingLatLong(GetUserLocation.currentPosition!.latitude.toString(), GetUserLocation.currentPosition!.longitude.toString());
      setState(() {
        weatherData = data;
        _screens = [
          Home(currentWeather: weatherData!),
          const Search(),
          const Weather(),
          const Profile(),
        ];
      });
    } catch (ex) {
      throw Exception('Home error: ${ex.toString()}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    if(_screens == null){
      return const Scaffold(
        body:  Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.location_on_rounded,
            color: Color(0xffA5C9CA),
          ),
          title: Text(
            weatherData!['name'].toString(),
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
        body: Center(
          child: _screens![_selectedIndex],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color(0x19ffffff),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: "Search"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.assistant_navigation), label: "Weather"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                ],
                currentIndex: _selectedIndex,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                selectedItemColor: const Color(0xffA5C9CA),
                unselectedItemColor: Colors.white38,
                elevation: 1,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
