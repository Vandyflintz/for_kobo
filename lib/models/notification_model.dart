/// total_notifications : 2

class NotificationModel {
final int totalNotifications;

NotificationModel({required this.totalNotifications});

factory NotificationModel.fromMap(Map<String, dynamic> map) {
  return NotificationModel(
    totalNotifications: map['total_notifications'] ?? 0,
  );
}

Map<String, dynamic> toMap() {
  return {
    'total_notifications': totalNotifications,
  };
}

}