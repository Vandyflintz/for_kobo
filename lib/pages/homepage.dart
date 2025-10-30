import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import 'homepage_screens/cards_page.dart';
import 'homepage_screens/dashboard.dart';
import 'homepage_screens/profile_page.dart';
import 'homepage_screens/stores.dart';
import 'homepage_screens/withdrawals.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  late UserProvider userProvider;

  void _onItemTapped(int index) {
    setState(() => _currentPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    userProvider = context.watch<UserProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left text
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Welcome back,\n",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: "${userProvider.user!.firstname}!",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Optional right bell icon
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.borderColorLightGrey,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_active,
                          color: AppColors.darkColor,
                          size: 16,
                        ),
                      ),
                      Positioned(
                        top: -14,
                        left: 16,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: AppColors.white,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              userProvider.notificationModel!.totalNotifications
                                  .toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentPageIndex,
                children: [
                  const DashboardPage(),
                  Withdrawals(),
                  StoresPage(),
                  CardsPage(),
                  ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.borderColorTopNavBarColor,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          // important so it blends
          elevation: 0,
          selectedLabelStyle: TextStyle(
            color: AppColors.darkColor,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColors.lightGreyBottomNavBarColor,
            fontWeight: FontWeight.w500,
          ),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/home_active.svg',
                colorFilter: setColorFilter(0, _currentPageIndex),
              ),
              icon: SvgPicture.asset(
                'assets/icons/home_inactive.svg',
                colorFilter: setColorFilter(0, _currentPageIndex),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/account_balance_wallet_active.svg',
                colorFilter: setColorFilter(1, _currentPageIndex),
              ),
              icon: SvgPicture.asset(
                'assets/icons/account_balance_wallet_inactive.svg',
                colorFilter: setColorFilter(1, _currentPageIndex),
              ),
              label: 'Withdrawals',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/storefront_active.svg',
                colorFilter: setColorFilter(2, _currentPageIndex),
              ),
              icon: SvgPicture.asset(
                'assets/icons/storefront_inactive.svg',
                colorFilter: setColorFilter(2, _currentPageIndex),
              ),
              label: 'Stores',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/icons/credit_card_active.svg',
                colorFilter: setColorFilter(3, _currentPageIndex),
              ),
              icon: SvgPicture.asset(
                'assets/icons/credit_card_inactive.svg',
                colorFilter: setColorFilter(3, _currentPageIndex),
              ),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                userProvider.user!.displayProfile,
                width: 24,
                height: 24,
              ),

              label: 'You',
            ),
          ],
          currentIndex: _currentPageIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withValues(alpha: .7),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
