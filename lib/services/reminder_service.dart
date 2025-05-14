import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

/// A comprehensive service to manage pet reminders
/// with Firestore integration and local notifications
class ReminderService {
  static final ReminderService _instance = ReminderService._internal();

  factory ReminderService() => _instance;

  ReminderService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize notifications and timezone data
  static Future<void> initNotifications() async {
    await ReminderService()._initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data first
      tz.initializeTimeZones();

      // Configure platform-specific notification settings
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize notifications plugin
      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Remove the problematic permission request for now
      // await _requestPermissions();

      _isInitialized = true;
      debugPrint('ReminderService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize ReminderService: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // For Android, we'll skip the problematic method for now
      // Instead of calling requestPermission(), let's check if permissions are enabled
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final bool? enabled = await androidPlugin.areNotificationsEnabled();
        debugPrint('Android notification permissions enabled: $enabled');
      }

      // Request iOS permissions
      final IOSFlutterLocalNotificationsPlugin? iosPlugin =
      _notifications.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }

  /// Handles notification tap events
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.id}');
    // Navigation logic can be added here
  }

  /// Create a new reminder
  static Future<String> addReminder(Map<String, dynamic> data) async {
    return await ReminderService()._addReminder(data);
  }

  Future<String> _addReminder(Map<String, dynamic> data) async {
    try {
      await _initialize();

      // Ensure required fields
      if (!data.containsKey('completed')) {
        data['completed'] = false;
      }

      // Add timestamps
      final reminderData = {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add to Firestore
      final doc = await _firestore.collection('reminders').add(reminderData);
      debugPrint('Added reminder with ID: ${doc.id}');

      return doc.id;
    } catch (e) {
      debugPrint('Failed to add reminder: $e');
      rethrow;
    }
  }

  /// Update an existing reminder
  static Future<void> updateReminder(String id, Map<String, dynamic> data) async {
    await ReminderService()._updateReminder(id, data);
  }

  Future<void> _updateReminder(String id, Map<String, dynamic> data) async {
    try {
      await _initialize();

      // Add updated timestamp
      final reminderData = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update in Firestore
      await _firestore.collection('reminders').doc(id).update(reminderData);
      debugPrint('Updated reminder with ID: $id');

      // Cancel existing notification
      await _notifications.cancel(id.hashCode);
      debugPrint('Cancelled existing notification for reminder: $id');

      // If reminder is completed, don't reschedule notification
      if (data.containsKey('completed') && data['completed'] == true) {
        debugPrint('Reminder is marked as completed, not scheduling notification');
        return;
      }

      // Reschedule notification if date is provided and in the future
      if (data.containsKey('date')) {
        try {
          // Parse the date - handle both DateTime objects and ISO strings
          final DateTime scheduledTime = data['date'] is String
              ? DateTime.parse(data['date'])
              : data['date'];

          if (scheduledTime.isAfter(DateTime.now())) {
            debugPrint('Scheduling notification for updated reminder: $id at $scheduledTime');
            await _scheduleReminderNotification(
              id: id.hashCode,
              title: data['title'] ?? 'Pet Reminder',
              scheduledTime: scheduledTime,
              body: data['description'] ?? 'Your pet reminder is due!',
            );
          } else {
            debugPrint('Not scheduling notification for past date: $scheduledTime');
          }
        } catch (e) {
          debugPrint('Error parsing date or scheduling notification: $e');
        }
      }
    } catch (e) {
      debugPrint('Failed to update reminder: $e');
      rethrow;
    }
  }

  /// Delete a reminder
  static Future<void> deleteReminder(String id) async {
    await ReminderService()._deleteReminder(id);
  }

  Future<void> _deleteReminder(String id) async {
    try {
      await _initialize();

      // Delete from Firestore
      await _firestore.collection('reminders').doc(id).delete();
      debugPrint('Deleted reminder with ID: $id');

      // Cancel any scheduled notification
      await _notifications.cancel(id.hashCode);
      debugPrint('Cancelled notification for deleted reminder: $id');
    } catch (e) {
      debugPrint('Failed to delete reminder: $e');
      rethrow;
    }
  }

  /// Schedule a notification for the reminder
  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
    String body = 'Your pet reminder is due!',
  }) async {
    await ReminderService()._scheduleReminderNotification(
      id: id,
      title: title,
      scheduledTime: scheduledTime,
      body: body,
    );
  }

  Future<void> _scheduleReminderNotification({
    required int id,
    required String title,
    required DateTime scheduledTime,
    String body = 'Your pet reminder is due!',
  }) async {
    try {
      await _initialize();

      // Create a TZDateTime from the provided DateTime
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      // Don't schedule if date is in the past
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      if (scheduledDate.isBefore(now)) {
        debugPrint('Cannot schedule notification in the past: $scheduledDate');
        return;
      }

      // Debug output to verify scheduling
      debugPrint('Scheduling notification #$id: "$title" for $scheduledDate');

      // Create the Android-specific notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Pet care reminders and notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
        playSound: true,
        enableLights: true,
        enableVibration: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
      );

      // Create the iOS-specific notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.aiff',
      );

      // Create the platform-specific notification details
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification
      // Fix: Use the modified version without the problematic parameter
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // Replace UILocalNotificationDateInterpretation with proper enum
        // Commented out as it's causing issues
        // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Verify notification was scheduled
      final List<PendingNotificationRequest> pendingNotifications =
      await _notifications.pendingNotificationRequests();

      debugPrint('Notification scheduled. Total pending: ${pendingNotifications.length}');

      // Check if our notification is among the pending ones
      final bool isScheduled = pendingNotifications.any((notification) => notification.id == id);
      debugPrint('Is notification #$id scheduled? $isScheduled');

    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }
  }

  /// Show an immediate test notification
  static Future<void> showTestNotification() async {
    await ReminderService()._showTestNotification();
  }

  Future<void> _showTestNotification() async {
    try {
      await _initialize();

      // Create the Android-specific notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Pet care reminders and notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
        playSound: true,
        enableLights: true,
        enableVibration: true,
      );

      // Create the iOS-specific notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.aiff',
      );

      // Create the platform-specific notification details
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Show the notification immediately
      await _notifications.show(
        0,
        'Test Notification',
        'This is a test notification to verify permissions',
        platformDetails,
      );

      debugPrint('Test notification sent');
    } catch (e) {
      debugPrint('Failed to show test notification: $e');
    }
  }

  /// Mark a reminder as completed
  static Future<void> markReminderAsCompleted(String id, bool completed) async {
    try {
      // Fix: Use the static method properly
      await ReminderService._instance._updateReminder(id, {'completed': completed});
      debugPrint('Reminder $id marked as completed: $completed');

      // Cancel notification if marked as completed
      if (completed) {
        await ReminderService()._notifications.cancel(id.hashCode);
        debugPrint('Cancelled notification for completed reminder: $id');
      }
    } catch (e) {
      debugPrint('Failed to mark reminder as completed: $e');
    }
  }

  /// Check if notifications are permitted and working
  static Future<bool> checkNotificationPermissions() async {
    return await ReminderService()._checkNotificationPermissions();
  }

  Future<bool> _checkNotificationPermissions() async {
    try {
      // For Android
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? areNotificationsEnabled =
      await androidPlugin?.areNotificationsEnabled();

      debugPrint('Android notifications enabled: $areNotificationsEnabled');

      return areNotificationsEnabled ?? false;
    } catch (e) {
      debugPrint('Error checking notification permissions: $e');
      return false;
    }
  }
}