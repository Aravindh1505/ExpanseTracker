import '../utils/local_notice_service.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  late final NotificationService notificationService;
  void registerPeriodicNotification() {
    notificationService = NotificationService();
    notificationService.showPeriodicLocalNotification(id: 0, title: 'Expanse Tracker', body: 'Daily Entry', payload: 'Dont miss daily entry, please add your todat entry');
  }

  void unregisterPeriodicNotification() {

  }
}