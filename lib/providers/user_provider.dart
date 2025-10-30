import 'package:flutter/material.dart';
import 'package:forkobo/models/notification_model.dart';

import '../data/app_data.dart';
import '../data/user_data.dart';
import '../models/user_model.dart';
class UserProvider extends ChangeNotifier {
  UserModel? _user;
  NotificationModel? _notificationModel;
  UserModel? get user => _user;
  NotificationModel? get notificationModel => _notificationModel;


 UserProvider(){
   loadUser(userData);
   loadNotification(notificationData);
}

  void loadUser(Map<String, dynamic> userMap) {
    _user = UserModel.fromMap(userMap);
    notifyListeners();
  }

  void loadNotification(Map<String, dynamic> notificationMap) {
    _notificationModel = NotificationModel.fromMap(notificationMap);
    notifyListeners();
  }
}