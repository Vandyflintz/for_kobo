import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forkobo/utils/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Withdrawals extends StatefulWidget {
  const Withdrawals({super.key});

  @override
  State<Withdrawals> createState() => _WithdrawalsState();
}

class _WithdrawalsState extends State<Withdrawals> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
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
            child:Center(
              child: Text("Withdrawals Page"),
            ),
          ),
      )
    );
  }
}
