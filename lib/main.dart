import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_app/screens/my_home_page.dart';
import 'package:weather_app/service/get_user_location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GetStarted(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool permissionGranted = false;
  Future<void> getLocationPermission() async{
    bool permission = await GetUserLocation.getCurrentPosition();
    setState(() {
       permissionGranted = permission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/7063/7063733.png"),
                        fit: BoxFit.fill)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Discover the Weather in Your City",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Get to know your weather maps and precipitation forecast",
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.white60),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await getLocationPermission();
                  print(permissionGranted);
                  if (permissionGranted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  } else {
                    String status = GetUserLocation.info;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(status, style: GoogleFonts.poppins(color: Colors.black,fontSize: 20),),backgroundColor: const Color(0xffE7F6F2),));
                  }
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff395B64),
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    "Get Started",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
