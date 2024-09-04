import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/weekstats_api.dart';
import 'package:hadja_grish/models/chart_model.dart';
import 'package:hadja_grish/models/week_stats_model.dart';
import 'package:http/http.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  ServicesApiStats api = ServicesApiStats();
  List<WeekStatsModel> weekStats = [];
  late String totalHebdo;
   late List<ModelBarData> modelBarData = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final res = await api.getStatsWeek();
      final data = res.data;
      if (res.statusCode == 200) {
        setState(() {
          weekStats = (data["stats"] as List)
              .map((json) => WeekStatsModel.fromJson(json))
              .toList();
          totalHebdo = data["totalHebdo"];
          modelBarData = weekStats.map((e) {
            return ModelBarData(
              x: int.parse(e.date.split("-")[1]),
              y: e.total.toDouble(),
            );
          }).toList();
        });
      }
    } catch (e) {
      // Gestion de l'erreur
      print('Erreur lors de la récupération des données : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF292D4E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: BarChart(
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.linear,
            BarChartData(
              minY: 0,
              maxY: 400000,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: myTitlesData(),
              barTouchData: myBarTouchData(modelBarData),
              barGroups: modelBarData.asMap().entries.map((item) {
                return BarChartGroupData(
                  x: item.key,
                  barRods: [
                    BarChartRodData(
                      toY: item.value.y,
                      gradient: const LinearGradient(
                        colors: [Colors.amber, Colors.red],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 400000,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Définir les titres des axes
  FlTitlesData myTitlesData() {
    return FlTitlesData(
      show: true,
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getBottomTitles,
        ),
      ),
    );
  }

  // Affichage des valeurs sur les barres
  BarTouchData myBarTouchData(List<ModelBarData> modelBarData) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        // tooltipBgColor: Colors.transparent,
        tooltipMargin: -10,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String weekDay;
          switch (group.x) {
            case 0:
              weekDay = "Lundi";
              break;
            case 1:
              weekDay = "Mardi";
              break;
            case 2:
              weekDay = "Mercredi";
              break;
            case 3:
              weekDay = "Jeudi";
              break;
            case 4:
              weekDay = "Vendredi";
              break;
            case 5:
              weekDay = "Samedi";
              break;
            case 6:
              weekDay = "Dimanche";
              break;
            default:
              weekDay = "";
          }
          String montant = "${modelBarData[group.x].y}";
          return BarTooltipItem(
            "$weekDay\n",
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: montant,
                style: const TextStyle(fontSize: 16, color: Colors.amber),
              ),
            ],
          );
        },
      ),
    );
  }

  // Titre de l'axe des abscisses
  Widget getBottomTitles(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(
          "Lun",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 1:
        text = Text(
          "Mar",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 2:
        text = Text(
          "Mer",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 3:
        text = Text(
          "Jeu",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 4:
        text = Text(
          "Ven",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 5:
        text = Text(
          "Sam",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      case 6:
        text = Text(
          "Dim",
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD5CEDD),
          ),
        );
        break;
      default:
        text = const Text('');
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
