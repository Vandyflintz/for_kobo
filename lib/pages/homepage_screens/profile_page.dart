import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        extendBody: true,
        body:  SafeArea(
            child:Column(
              children: [
                Text("Profile Page")
              ],
            ),

        ),)
        ;
  }
}
