class MonthStatsModel {
  final List<Stats> stats;
  final String totalMensuel;

  MonthStatsModel({required this.stats, required this.totalMensuel});

  factory MonthStatsModel.fromJson(Map<String, dynamic> json) {
    return MonthStatsModel(
        stats: (json["stats"] as List)
            .map((json) => Stats.fromJson(json))
            .toList(),
        totalMensuel: json["totalMensuel"]);
  }

  Map<String, dynamic> toJson() {
    return {"stats": stats, "totalMensuel": totalMensuel};
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
