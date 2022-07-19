import 'package:flutter/material.dart';
import 'package:code/RunEltModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:code/VDOTcalculus.dart';
import 'package:code/RunCalculus.dart';

class RunPowerView extends StatelessWidget {

  final RunElt runElt;
  const RunPowerView ({Key? key, required this.runElt}) : super(key: key);

  Widget _chartElement(double maxBarValue) {
    return Column(
      children: [/*
        Text("Power / Distance",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: /*[
                    FlSpot(1, 8),
                    FlSpot(2, 12.4),
                    FlSpot(3, 10.8),
                    FlSpot(4, 9),
                    FlSpot(5, 8),
                    FlSpot(6, 8.6),
                    FlSpot(7, 10)
                  ],*/
                  runElt.powerRunElt.map((point) => FlSpot(point.distElt, point.powerElt)).toList(),
                  color: Colors.redAccent,
              ),
            ]),
          ),
        ),*/

        Text("Effort / Zone",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          child: BarChart(BarChartData(
            maxY: maxBarValue + 10,
            barGroups:  [
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(fromY: 0, toY: runElt.numberOfEasyRunElt, width: 15, color: Colors.lightGreenAccent),
              ]),
              BarChartGroupData(x: 2, barRods: [
                BarChartRodData(fromY: 0, toY: runElt.numberOfModerateRunElt, width: 15, color: Colors.lightBlueAccent),
              ]),
              BarChartGroupData(x: 3, barRods: [
                BarChartRodData(fromY: 0, toY: runElt.numberOfThresholdRunElt, width: 15, color: Colors.yellowAccent),
              ]),
              BarChartGroupData(x: 4, barRods: [
                BarChartRodData(fromY: 0, toY: runElt.numberOfIntervalRunElt, width: 15, color: Colors.orangeAccent),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(fromY: 0, toY: runElt.numberOfRepetitionRunElt , width: 15, color: Colors.redAccent),
              ]),
            ]
          )),
        ),

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
          child: Column(
            children: [
              Text("Values",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Power Median",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(runElt.medianPowerRunElt.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.redAccent),),
                    Text(" W",style:TextStyle(fontSize: 20, color: Colors.redAccent,fontWeight: FontWeight.bold,)),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                  Text("Power Mean",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                  const VerticalDivider(
                    width: 50,
                    thickness: 5,
                  ),
                  Text(runElt.meanPowerRunElt.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.redAccent),),
                  Text(" W",style:TextStyle(fontSize: 20, color: Colors.redAccent,fontWeight: FontWeight.bold,)),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Speed Median",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(runElt.medianSpeedRunElt.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("VDOT",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(runElt.vdotValueRunElt.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                  ]
              ),
            ],
          ),
        ),
        Divider(
          height: 15,
          thickness: 5,
        ),
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
          child: Column(
            children: [
              Text("Estimation",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Power marathon",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(powerMarathon.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                    Text(" W",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Time for marathon",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(timeForMarathon,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.lightBlueAccent),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Power Half Marathon",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(powerHalfMarathon.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                    Text(" W",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Time for Half Marathon",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(timeForHalfMarathon,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.lightBlueAccent),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Power for 10km",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(powerTenKm.toStringAsFixed(0),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                    Text(" W",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.yellowAccent),),
                  ]
              ),
              Divider(
                height: 15,
                thickness: 5,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children:[
                    Text("Time for 10km",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
                    const VerticalDivider(
                      width: 50,
                      thickness: 5,
                    ),
                    Text(timeForTenKm,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.lightBlueAccent),),
                  ]
              ),
            ],
          ),
        ),

        /*
        Text(runElt.dateTimeRunELt.timeZoneName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.white),),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 300,
          child: LineChart(
            LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
              LineChartBarData(spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 3),
                const FlSpot(2, 10),
                const FlSpot(3, 7),
                const FlSpot(4, 12),
                const FlSpot(5, 13),
                const FlSpot(6, 17),
                const FlSpot(7, 15),
                const FlSpot(8, 20)
              ])
            ]),
          ),
        ),*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    List<double> barValueList =  [runElt.numberOfEasyRunElt,
      runElt.numberOfModerateRunElt,
      runElt.numberOfThresholdRunElt,
      runElt.numberOfIntervalRunElt,
      runElt.numberOfRepetitionRunElt
    ];
    double maxBarValue = barValueList.reduce((value, element) => value > element ? value : element);

    double vo2 = VO2(60 * runElt.medianSpeedRunElt);
    print("vo2");
    print(vo2);
    double vdot = VDOT(vo2,0.85);
    print("vdot " );
    print(vdot);

    double timeMarathon = target(42195,0.811,vdot);
    print("timeMarathon");
    print(timeMarathon);
    timeForMarathon = getCalculateTimeFromSecondes(timeMarathon * 60);
    double speedMarathon = 42195 / (timeMarathon * 60);
    paceMarathon = getPaceFromSpeed(speedMarathon);
    powerMarathon = getPowerWithSpeed(runElt.massRunElt, speedMarathon, 0.24, 0, 0, 0, 9.87);
    print("speedMarathon");
    print(speedMarathon);
    print("paceMarathon");
    print(paceMarathon);
    print("timeForMarathon");
    print(timeForMarathon);

    double timeHalfMarathon = target(21097.5,0.849,vdot);
    timeForHalfMarathon = getCalculateTimeFromSecondes (timeHalfMarathon * 60);
    double speedHalfMarathon = 21097.5 / (timeHalfMarathon * 60);
    paceHalfMarathon = getPaceFromSpeed(speedHalfMarathon);
    powerHalfMarathon = getPowerWithSpeed(runElt.massRunElt, speedHalfMarathon, 0.24, 0, 0, 0, 9.87);

    double timeTenKm = target(10000,0.903,vdot);
    timeForTenKm = getCalculateTimeFromSecondes(timeTenKm * 60);
    double speedTenKm = 10000 / (timeTenKm * 60);
    paceTenKm = getPaceFromSpeed(speedTenKm);
    powerTenKm = getPowerWithSpeed(runElt.massRunElt, speedTenKm, 0.24, 0, 0, 0, 9.87);

    print("List");
    print(runElt.powerRunElt.length);
    print(runElt.medianSpeedRunElt);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(runElt.dateTimeRunELt.toString(),style:TextStyle(fontSize: 20, color: Colors.white),)),
      body: Center(
      child:
        SingleChildScrollView(
          child: _chartElement(maxBarValue),
        ),
      ),
    );
  }
}


