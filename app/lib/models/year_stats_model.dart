class YearStatsModel {
  final List<Stats> stats;
  final String totalAnnuel;

  YearStatsModel({required this.stats, required this.totalAnnuel});

  factory YearStatsModel.fromJson(Map<String, dynamic> json) {
    return YearStatsModel(
        stats: (json["stats"] as List)
            .map((json) => Stats.fromJson(json))
            .toList(),
        totalAnnuel: json["totalAnnuel"]);
  }

  Map<String, dynamic> toJson() {
    return {"stats": stats, "totalAnnuel": totalAnnuel};
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
