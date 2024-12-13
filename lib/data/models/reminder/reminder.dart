import 'package:hive/hive.dart';
import 'package:intl/intl.dart';



@HiveType(typeId: 5) 
class Reminder extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  bool active; 

  @HiveField(3)
  final int id;

  @HiveField(4)
  String body;

  Reminder(
      {required this.title,
      required this.dateTime,
      this.active = true,
      required this.id,
      required this.body});

  String get formattedReminderTime => DateFormat('HH:mm').format(dateTime);

  Reminder copyWith({
    int? id,
    String? title,
    DateTime? dateTime,
    bool? active,
    String? body,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      active: active ?? this.active,
      body: body ?? this.body,
    );
  }
}