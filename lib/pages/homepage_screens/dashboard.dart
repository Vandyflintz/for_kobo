import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forkobo/providers/order_statistics_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/app_colors.dart';
import '../../widgets/homepage_chart.dart';
import '../../widgets/order_statistics_row.dart';
import '../../widgets/revenue_summary_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  late DashboardProvider dashboardProvider;
  @override
  Widget build(BuildContext context) {
    dashboardProvider = context.watch<DashboardProvider>();
    final summary = dashboardProvider.revenueSummary;
    final orderStatistics = dashboardProvider.orderStatistics;
    return Scaffold(
        backgroundColor: AppColors.white,
        extendBody: true,
        body:  SafeArea(
          child: SmartRefresher(
            physics: const BouncingScrollPhysics(),
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropHeader(
              refresh: SpinKitDoubleBounce(
                color: AppColors.cream,
                size: 30,
              ),
            ),
            controller: _refreshController,
            onRefresh: () async {
              _refreshController.refreshCompleted();
            },
            child:ListView(
              padding: EdgeInsets.only(top: 16, left: 12, right: 12),
              children: [
                RevenueSummaryCard(summary: summary!),
                SizedBox(height: 32,),
                PriceLineChart(),
                SizedBox(height: 32,),
                OrderStatisticsRow(orderStatistics: orderStatistics,)
              ],
            ),
          ),
        )
    );
  }
}
