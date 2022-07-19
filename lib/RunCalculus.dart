import 'dart:math';

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

getPowerWithSpeed(double mass, double speed, double Ar, double massVolumic, double speedWind, double rateElevation, double gravity) {
  return mass * speed +
      0.5 * Ar * massVolumic * (speed + speedWind) * (speed + speedWind)
          * speed +
      mass * gravity * rateElevation * speed;
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

getPaceStringFromSpeed( speed) {
  double paceFromSpeed = (60 / (speed * 3.6));
  int paceFromSpeedInteger = paceFromSpeed.round();
  double paceFromSpeedDecimal = (paceFromSpeed - paceFromSpeedInteger) * 60;
  StringBuffer sbPaceFromSpeed = new StringBuffer("");
  sbPaceFromSpeed.write(paceFromSpeedInteger);
  sbPaceFromSpeed.write(":");
  // if (paceFromSpeedDecimal < 10) {
  //    sbPaceFromSpeed.write("0");
  //    sbPaceFromSpeed.write(paceFromSpeedDecimal);
//  } else {
  sbPaceFromSpeed.write(paceFromSpeedDecimal);
  //}

  return sbPaceFromSpeed.toString().substring(1,2);
}

