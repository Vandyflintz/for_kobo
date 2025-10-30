class RevenueSummaryModel {
  final double totalRevenue;
  final double revenueChange;
  final int orders;
  final int ordersChange;
  final double grossProfit;
  final double grossProfitChange;
  final String nextPayout;
  final double pendingOrders;

  RevenueSummaryModel({
    required this.totalRevenue,
    required this.revenueChange,
    required this.orders,
    required this.ordersChange,
    required this.grossProfit,
    required this.grossProfitChange,
    required this.nextPayout,
    required this.pendingOrders,
  });

  factory RevenueSummaryModel.fromMap(Map<String, dynamic> map) {
    return RevenueSummaryModel(
      totalRevenue: (map['totalRevenue'] ?? 0).toDouble(),
      revenueChange: (map['revenueChange'] ?? 0).toDouble(),
      orders: (map['orders'] ?? 0).toInt(),
      ordersChange: (map['ordersChange'] ?? 0).toInt(),
      grossProfit: (map['grossProfit'] ?? 0).toDouble(),
      grossProfitChange: (map['grossProfitChange'] ?? 0).toDouble(),
      nextPayout: map['nextPayout'] ?? '',
      pendingOrders: (map['pendingOrders'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'totalRevenue': totalRevenue,
    'revenueChange': revenueChange,
    'orders': orders,
    'ordersChange': ordersChange,
    'grossProfit': grossProfit,
    'grossProfitChange': grossProfitChange,
    'nextPayout': nextPayout,
    'pendingOrders': pendingOrders,
  };
}
