import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

const reminderBoxName = 'remindersBox';

class ReminderList extends StatefulWidget {
  const ReminderList({super.key});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  final List<TextEditingController> dateTimeControllers = [];
  final uuid = const Uuid();
  final Map<int, bool> reminderNotificationStates = {};

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
  }

  @override
  void dispose() {
    for (final controller in dateTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _showTimePicker(
      BuildContext context, int index, Box<Reminder> box) async {
 
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(box.getAt(index)!.dateTime),
    );
    if (picked != null) {
      final newDateTime = DateTime(
        box.getAt(index)!.dateTime.year,
        box.getAt(index)!.dateTime.month,
        box.getAt(index)!.dateTime.day,
        picked.hour,
        picked.minute,
      );
      

      final updatedReminder = box.getAt(index)!.copyWith(dateTime: newDateTime, active: true);
      box.putAt(index, updatedReminder);

      setState(() {
        dateTimeControllers[index].text =
            DateFormat('HH:mm').format(newDateTime);
        final isScheduled =
            reminderNotificationStates[updatedReminder.id] ?? false;
        if (isScheduled) {
          _scheduleDailyTenAMNotification(updatedReminder.id, updatedReminder);
        }
      });
    }
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleDailyTenAMNotification(
      int id, Reminder reminder) async {
    final notificationDetails = await NotificationApi.notificationDetails();
    if (notificationDetails != null) {
      await NotificationApi.notification.zonedSchedule(
          id,
          'daily scheduled notification title',
          'daily scheduled notification body',
          _nextInstanceOfTenAM(),
          const NotificationDetails(
            android: AndroidNotificationDetails('daily notification channel id',
                'daily notification channel name',
                channelDescription: 'daily notification description'),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    } else {
      print('Failed to create notification details.');
    }
  }

  Future<void> _cancelNotification(int id) async {
    await NotificationApi.cancel(id);
    setState(() {
      reminderNotificationStates.remove(id); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Reminder>>(
      valueListenable: Hive.box<Reminder>(reminderBoxName).listenable(),
      builder: (context, box, child) {
        final reminders = box.values.toList();
        if (dateTimeControllers.length != reminders.length) {
          dateTimeControllers.clear();
          for (final reminder in reminders) {
            dateTimeControllers.add(TextEditingController(
              text: DateFormat('HH:mm').format(reminder.dateTime),
            ));
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reminders'),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: LeftButton(
                icon: Icons.arrow_left,
                onTap: () {
                  Navigator.pop(context);
                },
                iconColor: Colors.black,
                backgroundColor: Colors.transparent,
                borderColor: Colors.black12,
              ),
            ),
            ),
          body: reminders.isEmpty
              ? const Center(child: Text('No reminders found'))
              : ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return ListTile(
                      title: Text(reminder.title),
                      subtitle: TextField(
                        controller: dateTimeControllers[index],
                        readOnly: true,
                        onTap: () => _showTimePicker(context, index, box),
                        decoration:
                            const InputDecoration(hintText: 'Tap to set time'),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: reminder
                                .active, 
                            onChanged: (value) async {
                              final updatedReminder =
                                  reminder.copyWith(active: value);
                              box.putAt(index, updatedReminder);
                              if (value) {
                                await _scheduleDailyTenAMNotification(
                                    reminder.id, updatedReminder);
                              } else {
                                await _cancelNotification(reminder.id);
                              }
                              setState(() {}); 
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
            
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

extension ReminderExtension on Reminder {
   Reminder copyWith({int? id, String? title, DateTime? dateTime, bool? active}) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      active: active ?? this.active,
    );
  }
}

