import 'dart:convert';

import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class NotificationService {
  final AuthService _auth = AuthService();
  User? get currentUser => _auth.currentUser;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirestoreService firestoreService = FirestoreService();

  Future<String> getAccessToken() async {
    String jsonString = await rootBundle
        .loadString('assets/ai-mood-tracking-app-52ee5d5b7835.json');

    // Parse the JSON string into a Map<String, dynamic>
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert the dynamic values into String
    Map<String, String> serviceAccountJson = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //Obtain the Access Token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  // Function to get FCM token and store in Firebase Firestore
  Future<void> getAndStoreFCMToken() async {
    String? token = await messaging.getToken();
    if (token != null) {
      firestoreService.updateFCMToken(token);
    }
  }

  // Function to get FCM token only
  Future<String> getFCMToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  Future<void> sendNotification(
      String fcmToken, String title, String messageContent) async {
    // Replace 'YOUR_SERVER_KEY' with your Firebase server key
    String serverKey = await getAccessToken();
    String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/ai-mood-tracking-app/messages:send';
    Map<String, dynamic> message = {
      "message": {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': messageContent,
        },
        'data': {
          "current_user_fcm_token": fcmToken,
        }
      }
    };

    // Make an HTTP POST request to FCM endpoint
    http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }

// Function to display notification and navigate to a specific screen onTap using flutter_local_notifications
  void displayNotification(BuildContext context, String message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Notification',
      message,
      platformChannelSpecifics,
      payload: 'screenRoute', // Route to navigate when notification is tapped
    );
  }

// Function to handle notification onTap action and navigate to a specific screen
  void handleNotificationTap(String payload) {
    // Handle navigation to specific screen based on payload
    if (payload == 'screenRoute') {
      // Navigate to specific screen
      // Example: Navigator.pushNamed(context, '/specific_screen');
    }
  }
}
