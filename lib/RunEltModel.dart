import 'package:code/PowerEltModel.dart';


class RunElt {
  int identRunElt;
  DateTime dateTimeRunELt;
  List<PowerElt> PowerRunElt;
  double medianPowerRunElt, meanPowerRunElt;
  double medianSpeedRunElt;
  double percentMaxRunElt, vo2ValueRunElt, vdotValueRunElt;
  int numberOfEasyRunElt;
  int numberOfModerateRunElt;
  int numberOfThresholdRunElt;
  int numberOfIntervalRunElt;
  int numberOfRepetitionRunElt;
  RunElt({required this.identRunElt,
    required this.dateTimeRunELt,
    required this.PowerRunElt,
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