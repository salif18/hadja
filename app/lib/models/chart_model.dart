import 'package:flutter/material.dart';

class ModelLineData {
  double x;
  double y;
  
  ModelLineData({required this.x, required this.y});
}


class ModelBarData{
  int x;
  double y;

  ModelBarData({required this.x, required this.y});
}

class ModelPieData{
  double value;
  String title;
  Color color;

  ModelPieData({required this.value, required this.title, required this.color});
}