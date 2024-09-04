class WeekStatsModel {
 final String date;
 final int total;

  WeekStatsModel({required this.date, required this.total});

  factory WeekStatsModel.fromJson(Map<String, dynamic> json) {
    return WeekStatsModel(date: json["date"], total: json["total"]);
  }

  Map<String, dynamic> toJson() {
    return {"date": date, "total": total};
  }
}
