import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/app_colors.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
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
              child: Text("Cards Page"),
            ),
          ),
        )
    );
  }
}
