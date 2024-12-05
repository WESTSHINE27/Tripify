class AdReport {
  final String adId;
  final DateTime reportDate;
  final int clickCount;
  final double engagementRate;
  final double successRate;
  final int reach;
  final double cost;
  final double cpc;
  final double revenue;
  final double roas;

  AdReport({
    required this.adId,
    required this.reportDate,
    required this.clickCount,
    required this.engagementRate,
    required this.successRate,
    required this.reach,
    required this.cost,
    required this.cpc,
    required this.revenue,
    required this.roas,
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'reportDate': reportDate,
      'clickCount': clickCount,
      'engagementRate': engagementRate,
      'successRate': successRate,
      'reach': reach,
      'cost': cost,
      'cpc': cpc,
      'revenue': revenue,
      'roas': roas,
    };
  }
}