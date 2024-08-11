class WeekStatsModel {
  final List<Stats> stats;
  final String totalHebdo;

  WeekStatsModel({required this.stats, required this.totalHebdo});

  factory WeekStatsModel.fromJson(Map<String, dynamic> json) {
    return WeekStatsModel(
        stats: (json["stats"] as List)
            .map((json) => Stats.fromJson(json))
            .toList(),
        totalHebdo: json["totalHebdo"]);
  }

  Map<String, dynamic> toJson() {
    return {"stats": stats, "totalHebdo": totalHebdo};
  }
}

class Stats {
  String date;
  String total;

  Stats({required this.date, required this.total});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(date: json["date"], total: json["total"]);
  }

  Map<String, dynamic> toJson() {
    return {"date": date, "total": total};
  }
}
