import 'package:code/PowerEltModel.dart';

double paceMarathon = 0;
double powerMarathon = 0;
String timeForMarathon = "";

double paceHalfMarathon = 0;
double powerHalfMarathon = 0;
String timeForHalfMarathon = "";

double paceTenKm = 0;
double powerTenKm = 0;
String timeForTenKm = "";

class RunElt {
  int identRunElt;
  DateTime dateTimeRunELt;
  double massRunElt;
  List<PowerElt> powerRunElt;
  double medianPowerRunElt, meanPowerRunElt;
  double medianSpeedRunElt;
  double percentMaxRunElt, vo2ValueRunElt, vdotValueRunElt;
  double numberOfEasyRunElt;
  double numberOfModerateRunElt;
  double numberOfThresholdRunElt;
  double numberOfIntervalRunElt;
  double numberOfRepetitionRunElt;
  RunElt({required this.identRunElt,
    required this.dateTimeRunELt,
    required this.massRunElt,
    required this.powerRunElt,
    required this.medianPowerRunElt, required this.meanPowerRunElt,
    required this.medianSpeedRunElt,
    required this.percentMaxRunElt, required this.vo2ValueRunElt, required this.vdotValueRunElt,
    required this.numberOfEasyRunElt,
    required this.numberOfModerateRunElt,
    required this.numberOfThresholdRunElt,
    required this.numberOfIntervalRunElt,
    required this.numberOfRepetitionRunElt
  });
}