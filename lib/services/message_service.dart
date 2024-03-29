import 'package:ai_mood_tracking_application/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    //get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
        unread: true);

    //add message and chatroom (if it didn't exist) to database
    String chatRoomId = getChatRoomId(currentUserId, receiverId);
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  String getChatRoomId(String firstUserId, String secondUserId) {
    List<String> ids = [firstUserId, secondUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return chatRoomId;
  }

  Future<void> setMultipleMessageAsRead(
      String readerId, String senderId) async {
    String chatRoomId = getChatRoomId(readerId, senderId);
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .where("receiverId", isEqualTo: readerId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({"unread": false});
    }
  }

  //Get Messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);
    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLatestMessage(
      String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);
    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots();
  }
}
