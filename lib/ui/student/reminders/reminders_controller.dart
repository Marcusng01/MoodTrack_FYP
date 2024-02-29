import 'package:ai_mood_tracking_application/data/reminder_item.dart';
import 'package:ai_mood_tracking_application/services/firestore_service.dart';

class RemindersController {
  FirestoreService firestoreService = FirestoreService();
  late List<ReminderItem> data;
  late List<bool> isExpanded;
  late bool isInitialiseIsExpanded = true;
}
