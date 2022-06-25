import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:code/RunEltModel.dart';
import 'package:code/PowerEltModel.dart';
import 'RunPowerView.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page first'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  String long = "", lat = "";
  double longElt = 0 , latElt = 0;
  late StreamSubscription<Position> positionStream;

  GoogleMapController? mapController; //contrller for Google map

  static  LatLng _kMapCenter = LatLng(0, 0);

  static  CameraPosition _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);


  double mass = 75;
  double Ar = 0.24;
  double gravity = 9.81;
  double speedWind = 0;
  double temperature = 15;
  double pressureATM = 101325;
  double pressureSaturation = 0;
  double percentHumidity = 50;
  double massVolumic = 0;
  double rateElevation = 0;

  double easyPaceMin = 0;
  double easyPaceMax = 0;
  double moderatePaceMin = 0;
  double moderatePaceMax = 0;
  double thresholdPaceMin = 0;
  double thresholdPaceMax = 0;
  double intervalPaceMin = 0;
  double intervalPaceMax = 0;
  double repetitionPaceMin = 0;
  double repetitionPaceMax = 0;
  int numberOfEasy = 0;
  int numberOfModerate = 0;
  int numberOfThreshold = 0;
  int numberOfInterval = 0;
  int numberOfRepetition = 0;


  List<LatLongElt> latLongList = [];
  int numberOfEltInLatLongList = 0;

  List<PowerElt> powerEltList = [];
  //PowerElt powerElt = PowerElt(identElt: 1, distElt: 1, timeElt: 1, powerElt: 1, speedElt: 1, paceElt: 1, meanPowerElt: 1, medianPowerElt: 1, medianSpeedElt: 1, percentMaxElt: 1, vo2ValueElt: 1, vdotValueElt: 1);
  List<RunElt> runEltList = [];

  double deltaDistancePowerActivity = 0;
  int deltaTimezonePowerActivity = 0;

  DateTime dateTime = DateTime.now();
  //String second = "" ;

  double timeFromStart = 0;
  String timeFromStartString = "";
  double distanceFromStart = 0;
  String distanceFromStartString = "";

  double power = 0;
  String powerString ="";
  double sumOfPower = 0;
  int numberOfPower = 0;
  double meanPower = 0;
  List<double> mList = <double>[];
  List<double> sList = <double>[];
  double medianPower = 0;
  double speed = 0;
  double medianSpeed = 0;
  double pace = 0;
  double percentMax = 0;
  double vo2Value = 0;
  double vdotValue = 0;

  String stateOfRun = "Go";
  String stateOfRunString = "Pause";
  bool  IsRunRecorded = false ;
  int identEltRecorded = 0;

  String _text = '';

  //List Widget Begin

  Widget _buildRow(int idx) {
    return ListTile(
      title: Text(runEltList[idx].identRunElt.toString(),style:TextStyle(fontSize: 20, color: Colors.white),),
      leading: SizedBox(
        width: 50,
        height: 50,
    //    child: Image.network(Fruitdata[index].ImageUrl),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RunPowerView(runElt: runEltList[idx],)));
      },
    );
  }

  //List Widget End


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  newLocation (){
      LatLng newlatlang = LatLng(position.latitude,position.longitude);
      mapController?.animateCamera(
         CameraUpdate.newCameraPosition(
         CameraPosition(target: newlatlang, zoom: 17)
         //17 is new zoom level
      )
      );
  //move position of map camera to new location
  }


  getLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //print(position.longitude);
      //print(position.latitude);

      long = position.longitude.toString();
      lat = position.latitude.toString();

      dateTime = DateTime.now();

      latLongList.add(
          LatLongElt(LatElt: position.latitude, LongElt: position.longitude, dateTimeElt: dateTime, altElt: position.altitude));
      numberOfEltInLatLongList = numberOfEltInLatLongList + 1;
    } on Exception {
      return null;
    }

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
   //   distanceFilter: 10, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      //print(position.longitude);
      //print(position.latitude);
      //print(position);

      long = position.longitude.toString();
      lat = position.latitude.toString();
      longElt = position.longitude;
      latElt = position.latitude;
      dateTime = DateTime.now();

      latLongList.add(LatLongElt(LatElt: position.latitude, LongElt: position.longitude, dateTimeElt: dateTime, altElt: position.altitude));
      numberOfEltInLatLongList = numberOfEltInLatLongList + 1;
      latLongList.length;


      if (latLongList.length > 3) {
        deltaDistancePowerActivity = getDistanceFromLatLontoMeter(
            latLongList.elementAt(latLongList.length - 2).LatElt,
            latLongList.elementAt(latLongList.length - 2).LongElt,
            latLongList.elementAt(latLongList.length - 1).LatElt,
            latLongList.elementAt(latLongList.length - 1).LongElt
        );

        distanceFromStart = distanceFromStart + deltaDistancePowerActivity;

        distanceFromStartString = (distanceFromStart / 1000).toStringAsFixed(3);

        deltaTimezonePowerActivity = getDeltaTimeFromTimezoneString(
            latLongList.elementAt(latLongList.length - 2).dateTimeElt,
            latLongList.elementAt(latLongList.length - 1).dateTimeElt
        );

        timeFromStart = timeFromStart + deltaTimezonePowerActivity;

        //timeFromStartString = timeFromStart.toStringAsFixed(2);

        timeFromStartString = getCalculateTimeFromSecondes(timeFromStart);


        pressureSaturation = toBuckEquation(temperature);

        massVolumic = toTransformMassVolumic(percentHumidity,pressureSaturation,pressureATM,temperature);

    //    rateElevation = (latLongList.elementAt(latLongList.length-1).altElt - latLongList.elementAt(latLongList.length-2).altElt) / latLongList.elementAt(latLongList.length-1).altElt;

        power = getPower(mass, deltaDistancePowerActivity, deltaTimezonePowerActivity, Ar, massVolumic, speedWind, rateElevation, gravity);

        powerString = power.toStringAsFixed(2);


        if (IsRunRecorded && !power.isNaN) {
          identEltRecorded = identEltRecorded + 1;
          print("ElemenentOfPower");
          print(identEltRecorded);
          print(distanceFromStartString);
          print(timeFromStartString);
          print(power);

          numberOfPower = numberOfPower + 1;
          sumOfPower = sumOfPower + power;
          meanPower = sumOfPower / numberOfPower;
          print("meanPower :");
          print(meanPower);

          speed = getSpeedFromDistanceAndTime(deltaDistancePowerActivity, deltaTimezonePowerActivity);
          print("speed");
          print(speed);

          pace = getPaceFromSpeed(speed);
          print("pace");
          print(pace);

          mList.add(power);
          medianPower = calculateMedian(mList);
          print("evolution of median Power...");
          print(medianPower);

          sList.add(speed);
          medianSpeed = calculateMedian(sList);
          print("evolution of median Speed... ");
          print(medianSpeed);

          percentMax = percentValue(timeFromStart / 60);
          print("evolution of percentMax during time from Start");
          print(percentMax);

          vo2Value = VO2(medianSpeed * 60);
          print("evolution of vo2 during time from Start");
          print(vo2Value);

          vdotValue = VDOT(vo2Value, percentMax);
          print("evolution of vdot during time from Start");
          print(vdotValue);

          powerEltList.add(PowerElt(
              identElt: identEltRecorded,
              distElt: distanceFromStart,
              timeElt: timeFromStart,
              powerElt: power,
              speedElt: speed,
              paceElt: pace,
              meanPowerElt: meanPower,
              medianPowerElt: medianPower,
              medianSpeedElt: medianSpeed,
              percentMaxElt: percentMax,
              vo2ValueElt: vo2Value,
              vdotValueElt: vdotValue
          ));
        }
      } else {
        power = 0;
      }


      setState(() {
        //refresh UI on update
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        //    title: Text("Runpower"),
            backgroundColor: Colors.black
        ),
        /*
        floatingActionButton: FloatingActionButton(
          child: Text("$stateOfRun"),
          onPressed: (){
            LatLng newlatlang = LatLng(latElt,longElt);

            if (!IsRunRecorded) {
              IsRunRecorded = true;
              stateOfRun = "Pause";
              stateOfRunString = "Recording...";
            } else {
              IsRunRecorded = false;
              stateOfRun = "Go";
              stateOfRunString = "Pause...";
            }


          },
        ),
         */
        floatingActionButton: SpeedDial(
          child: const Icon(Icons.add),
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              child: const Icon(Icons.directions_run),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              //label: 'Let\'s go for a run!',
              label: stateOfRunString,
              onPressed: () {
                if (!IsRunRecorded) {
                  IsRunRecorded = true;
                  stateOfRun = "Pause";
                  stateOfRunString = "Recording...";
                } else {
                  IsRunRecorded = false;
                  stateOfRun = "Go";
                  stateOfRunString = "Pause...";
                }
                setState(() {
                  _text = stateOfRunString;
                });
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.delete),
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              label: 'Dismiss',
              onPressed: () {

                IsRunRecorded = false;
                stateOfRun = "Go";
                stateOfRunString = "Pause...";

                //Tout mettre à zero....
                latLongList.clear();
                numberOfEltInLatLongList = 0;

                powerEltList.clear();

                deltaDistancePowerActivity = 0;
                deltaTimezonePowerActivity = 0;

                dateTime = DateTime.now();
             //   second = "" ;


                timeFromStart = 0;
                timeFromStartString = "";
                distanceFromStart = 0;
                distanceFromStartString = "";

                power = 0;
                powerString ="";
                sumOfPower = 0;
                numberOfPower = 0;
                meanPower = 0;
                mList.clear();
                sList.clear();
                medianPower = 0;
                speed = 0;
                medianSpeed = 0;
                pace = 0;
                percentMax = 0;
                vo2Value = 0;
                vdotValue = 0;

                identEltRecorded = 0;

                _text = '';


                setState(() {
                  _text = 'Dismiss...';
                });
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.save),
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightBlueAccent,
              label: 'Save',
              onPressed: () {

                IsRunRecorded = false;
                stateOfRun = "Go";
                stateOfRunString = "Pause...";

                print(powerEltList.length);

                print(powerEltList[powerEltList.length - 1].vdotValueElt);
                print(powerEltList[powerEltList.length - 1].medianPowerElt);
                print(powerEltList[powerEltList.length - 1].meanPowerElt);

                easyPaceMin = target(1000,0.59,powerEltList[powerEltList.length - 1].vdotValueElt) ;
                easyPaceMax = target(1000,0.74,powerEltList[powerEltList.length - 1].vdotValueElt) ;
                moderatePaceMin = target(1000,0.75,powerEltList[powerEltList.length - 1].vdotValueElt);
                moderatePaceMax = target(1000,0.83,powerEltList[powerEltList.length - 1].vdotValueElt);
                thresholdPaceMin = target(1000,0.84,powerEltList[powerEltList.length - 1].vdotValueElt);
                thresholdPaceMax = target(1000,0.88,powerEltList[powerEltList.length - 1].vdotValueElt);
                intervalPaceMin = target(1000,0.95, powerEltList[powerEltList.length - 1].vdotValueElt);
                intervalPaceMax = target(1000,1.0, powerEltList[powerEltList.length - 1].vdotValueElt);
                repetitionPaceMin = target(1000, 1.05, powerEltList[powerEltList.length - 1].vdotValueElt);
                repetitionPaceMax = target(1000, 1.20, powerEltList[powerEltList.length - 1].vdotValueElt);



                numberOfEasy = 0;
                numberOfModerate = 0;
                numberOfThreshold = 0;
                numberOfInterval = 0;
                numberOfRepetition = 0;

                for (PowerElt powerElt in powerEltList) {

                  print(powerElt.paceElt);
                  if (powerElt.paceElt >= easyPaceMax) {
                    numberOfEasy = numberOfEasy + 1;
                  } else {
                    if ((moderatePaceMax <= powerElt.paceElt)) { //&& (powerElt.paceElt <= moderatePaceMax)) {
                      numberOfModerate = numberOfModerate + 1;
                    } else {
                      if ((thresholdPaceMax <= powerElt.paceElt)) {// && (powerElt.paceElt <= thresholdPaceMin)) {
                        numberOfThreshold = numberOfThreshold + 1;
                      } else {
                        if ((intervalPaceMax <= powerElt.paceElt)) {//&& (powerElt.paceElt <= intervalPaceMax)) {
                          numberOfInterval = numberOfInterval + 1;
                        } else {
                   //       if ((repetitionPaceMax <= powerElt.paceElt)) {//&& (powerElt.paceElt <= repetitionPaceMax)) {
                            numberOfRepetition = numberOfRepetition + 1;
                      //    }
                        }
                      }
                    }
                  }

                }

                print("intervals");
                print(easyPaceMin);
                print(easyPaceMax);
                print(moderatePaceMin);
                print(moderatePaceMax);
                print(thresholdPaceMin);
                print(thresholdPaceMax);
                print(intervalPaceMin);
                print(intervalPaceMax);
                print(repetitionPaceMin);
                print(repetitionPaceMax);
                print("numbers");
                print(numberOfEasy);
                print(numberOfModerate);
                print(numberOfThreshold);
                print(numberOfInterval);
                print(numberOfRepetition);

                RunElt runElt =  RunElt(identRunElt: DateTime.now().hashCode,
                                dateTimeRunELt: DateTime.now(),
                                PowerRunElt: powerEltList,
                                medianPowerRunElt: powerEltList[powerEltList.length - 1].medianPowerElt,
                                meanPowerRunElt: powerEltList[powerEltList.length - 1].meanPowerElt,
                                medianSpeedRunElt: powerEltList[powerEltList.length - 1].medianSpeedElt,
                                percentMaxRunElt: powerEltList[powerEltList.length - 1].percentMaxElt,
                                vo2ValueRunElt: powerEltList[powerEltList.length - 1].vo2ValueElt,
                                vdotValueRunElt: powerEltList[powerEltList.length - 1].vdotValueElt,
                                numberOfEasyRunElt: numberOfEasy,
                                numberOfModerateRunElt: numberOfModerate,
                                numberOfThresholdRunElt: numberOfThreshold,
                                numberOfIntervalRunElt: numberOfInterval,
                                numberOfRepetitionRunElt: numberOfRepetition);

                runEltList.add(runElt);

                setState(() {
                  _text = 'Save ! ';
                });
              },
            ),
          ],
          closedForegroundColor: Colors.black,
          openForegroundColor: Colors.white,
          closedBackgroundColor: Colors.white,
          openBackgroundColor: Colors.black,
        ),

        body:
        Center(
            child: Column(
              children: <Widget>[
                Card(
                  color: Color.fromRGBO(50, 50, 50, 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
               //   child: SizedBox(
                 //   height: 400.0,
                    child: Column(
                      children: <Widget>[
                        Text(servicestatus? "GPS status is Enabled": "GPS status is disabled.",style:TextStyle(fontSize: 15, color: Colors.white),),
                        Text(haspermission? "GPS permission is Enabled": "GPS permission is disabled.",style:TextStyle(fontSize: 15, color: Colors.white),),
                        Text("Longitude: $long", style:TextStyle(fontSize: 20, color: Colors.white),),
                        Text("Latitude: $lat", style:TextStyle(fontSize: 20, color: Colors.white),),
                        const Divider(
                          height: 50,
                          thickness: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children:   <Widget>[
                            Text("Power :",style:TextStyle(fontSize: 20, color: Colors.white),),
                            const VerticalDivider(
                              width: 50,
                              thickness: 5,
                            ),
                            Text("$powerString",style:TextStyle(fontSize: 20, color: Colors.redAccent,fontWeight: FontWeight.bold,)),
                          ],
                        ),
                        const Divider(
                          height: 50,
                          thickness: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children:   <Widget>[
                            Text("Time :",style:TextStyle(fontSize: 20, color: Colors.white),),
                            const VerticalDivider(
                              width: 50,
                              thickness: 5,
                            ),
                            Text("$timeFromStartString",style:TextStyle(fontSize: 20, color: Colors.yellowAccent,fontWeight: FontWeight.bold,)),
                          ],
                        ),
                        const Divider(
                          height: 50,
                          thickness: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children:   <Widget>[
                            Text("Distance :",style:TextStyle(fontSize: 20, color: Colors.white),),
                            const VerticalDivider(
                              width: 50,
                              thickness: 5,
                            ),
                            Text("$distanceFromStartString",style:TextStyle(fontSize: 20, color: Colors.lightBlueAccent,fontWeight: FontWeight.bold,)),
                            Text(" km",style:TextStyle(fontSize: 20, color: Colors.lightBlueAccent,fontWeight: FontWeight.bold,)),
                          ],
                        ),
                        const Divider(
                          height: 50,
                          thickness: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children:   <Widget>[
                            Text("$stateOfRunString",style:TextStyle(fontSize: 20, color: Colors.white),),
                          ],
                        ),

                      ],
                    ),
                  ),
                Column(

                  children:  <Widget>[
                    Text("RunPowerList",style:TextStyle(fontSize: 20, color: Colors.white),),

                  ],
                ),
                Expanded(
                  child:Card(
                    color: Color.fromRGBO(50, 50, 50, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                          child:
                          ListView.builder(
                            itemCount: runEltList.length,
                            padding: const EdgeInsets.all(16.0),
                            itemBuilder: (BuildContext context, int index) {
                        //      if (i.isOdd) return const Divider();
                        //      final index = i ~/ 2 + 1;
                              return _buildRow(index);
                            },
                          ),

                          /*
                          ListView(
                            children: const <Widget>[
                              ListTile(
                                title:Text("111",style:TextStyle(fontSize: 20, color: Colors.white),),
                              ),
                            ],
                          ),*/
                        ),
                    ),


           //     ),

                /*            SizedBox(
                  width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                  height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height/2,
                  child:
                    GoogleMap(
                      myLocationEnabled: true,
                      initialCameraPosition: _kInitialPosition,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
                    ),
                ),*/
              ],

            )

        )

    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}

// methods
// run calculus
getDistanceFromLatLontoMeter(double lat1, double lon1, double lat2, double lon2) {
  double earthRadius = 6371;
  double dLat = degToRad(lat2-lat1);
  double dLon = degToRad(lon2-lon1);
  double intResA =  (sin(dLat/2) * sin(dLat/2) +
      cos(degToRad(lat1)) * cos(degToRad(lat2)) * sin(dLon/2) * sin(dLon/2));
  double intResB =  (2 * atan2(sqrt(intResA), sqrt(1-intResA)));
  double dDist = 1000 * (earthRadius * intResB);
  return dDist;
}

degToRad(double deg) {
return (deg * (pi / 180));
}

getDeltaTimeFromTimezoneString(DateTime timezone1, DateTime timezone2){
  int timezoneStartPoint = 3600 * (timezone1.hour) + 60 * (timezone1.minute) + timezone1.second;
  int timezoneEndPoint = 3600 * (timezone2.hour) + 60 * (timezone2.minute) + timezone2.second;
  return  (timezoneEndPoint - timezoneStartPoint);
}

getPower(double mass, double deltaDistance, int deltaTime, double Ar, double massVolumic, double speedWind, double rateElevation, double gravity) {
  return mass * (deltaDistance / deltaTime) +
      0.5 * Ar * massVolumic * (deltaDistance / deltaTime + speedWind) * (deltaDistance / deltaTime + speedWind)
      * deltaDistance/deltaTime +
      mass * gravity * rateElevation * (deltaDistance / deltaTime);
}

toTransformMassVolumic (double percentHumidity, double pressureSaturation, double pressureATM, double temperature) {
  double temperatureKelvin = temperature + 273.15;
  double Rs = 287.058;
  double Humidity = percentHumidity / 100;

  return (1.0 - (0.3783 * Humidity * pressureSaturation) / pressureATM) * pressureATM / (Rs * temperatureKelvin);
}

toBuckEquation (double temperature) {
  double forBuckEquation = (18.878 - (temperature / 234.5)) * (temperature / (257.14 + temperature));
  return (611.21 * exp(forBuckEquation));
}

getCalculateTimeFromSecondes(var seconds) {
  //print("TimeFromSeondes");
  //print("sec");
  var sec = seconds % 60;
  //print(sec);
  //print("min");
  var min = seconds % 3600 / 60;
  //print(min);
  //print("hours");
  var hours = seconds % 86400 / 3600;
  //print(hours);
  //print("days");
  var days = seconds / 86400;
  //print(days.truncate());
  StringBuffer sbCalculateTime = new StringBuffer();
  if (days.truncate() != 0) {
    sbCalculateTime.write(days.truncate());
    sbCalculateTime.write("days");
  }
  if (hours.truncate() != 0) {
    sbCalculateTime.write(hours.truncate());
    sbCalculateTime.write("h");
  }
  if (min.truncate() != 0) {
    sbCalculateTime.write(min.truncate());
    sbCalculateTime.write("m");
  }
  if (sec.truncate() != 0) {
    sbCalculateTime.write(sec.truncate());
    sbCalculateTime.write("s");
  }
  String timeCalculateString = sbCalculateTime.toString();
  //print("time");
  //print(timeCalculateString);

  return timeCalculateString;
}

calculateMedian(List<double> clonedList) {
  //List<int> mList = List();
  //timeRecordNotifier.timeRecords.forEach((element) {
  //  mList.add(element.partialTime);
  //});

  //clone list
  //List<int> clonedList = List();
  //clonedList.addAll(mList);

  //sort list
  clonedList.sort((a, b) => a.compareTo(b));

  double median;

  int middle = clonedList.length ~/ 2;
  if (clonedList.length % 2 == 1) {
    median = clonedList[middle];
  } else {
    median = ((clonedList[middle - 1] + clonedList[middle]) / 2.0);
  }

  return median;
}

getSpeedFromDistanceAndTime(double distance, int time) {
  return distance / time;
}

getPaceFromSpeed(double speed) {
  return (60.0 / (speed * 3.6));
}


//VDOT calculus
percentValue(double time)  {

  double percent = 0.8 + 0.1894393 * exp(-0.012778 * time) + 0.2989558 * exp(-0.1932605 * time);

  return percent;

}

VO2 (double speed) {

  double VO2 = -4.6 + 0.182258 * speed + 0.000104 * (speed * speed);

  return VO2;

}

VDOT (double VO2, double percentMax) {

  double VDOT = VO2 / percentMax;

  return VDOT;

}

target (double dist, double percent, double vdot) {

  double target = (dist * 2 * 0.000104) / (-0.182258 +
                    sqrt(0.182258 * 0.182258 - 4 * 0.000104 * (-4.6 - percent * vdot)));

  return target;

}


// Class
class LatLongElt{ //modal class for Latitude Longitude Element object
  double  LatElt, LongElt, altElt;
  DateTime dateTimeElt;
  LatLongElt({required this.LatElt, required this.LongElt, required this.dateTimeElt, required this.altElt});
}

