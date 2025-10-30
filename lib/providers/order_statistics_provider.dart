import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/order_statistics_model.dart';
import '../models/revenue_summary_model.dart';

class DashboardProvider extends ChangeNotifier {
  List<OrderStatisticsModel> _orderStatistics = [];
  RevenueSummaryModel? _revenueSummary;

  List<OrderStatisticsModel> get orderStatistics => _orderStatistics;
  RevenueSummaryModel? get revenueSummary => _revenueSummary;

  DashboardProvider(){
    loadDashboardData();
  }

  void loadDashboardData() {
    // Mock initialization
    _orderStatistics = orderStatisticsData
        .map((data) => OrderStatisticsModel.fromMap(data))
        .toList();

    _revenueSummary = RevenueSummaryModel.fromMap(revenueSummaryData);
    notifyListeners();
  }

  void updateRevenue(double newRevenue, double change) {
    if (_revenueSummary != null) {
      _revenueSummary = RevenueSummaryModel(
        totalRevenue: newRevenue,
        revenueChange: change,
        orders: _revenueSummary!.orders,
        ordersChange: _revenueSummary!.ordersChange,
        grossProfit: _revenueSummary!.grossProfit,
        grossProfitChange: _revenueSummary!.grossProfitChange,
        nextPayout: _revenueSummary!.nextPayout,
        pendingOrders: _revenueSummary!.pendingOrders,
      );
      notifyListeners();
    }
  }
}
