import 'dart:math';

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
