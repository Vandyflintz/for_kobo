import 'package:flutter/material.dart';
import 'package:forkobo/providers/order_statistics_provider.dart';
import 'package:forkobo/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
