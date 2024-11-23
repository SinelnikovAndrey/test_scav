import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';


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
    LocalNotifications.init();
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

      final updatedReminder =
          box.getAt(index)!.copyWith(dateTime: newDateTime, active: true);
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
    final notificationDetails = await LocalNotifications.notificationDetails();
    if (notificationDetails == null) {
      print('Error: Notification details are null');
      return;
    }

    try {
      await LocalNotifications.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Daily Scavenger',
        'Check your ${reminder.title} items',
        _nextInstanceOfTenAM(),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('reminder for ${reminder.title} added successfully!')));
      print(
          'Scheduled notification for ID: $id, title: ${reminder.title}, time: ${reminder.dateTime}');
    } catch (e) {
      print('Error scheduling notification for ID $id: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {});
    }
  }

  Future<void> _cancelNotification(int id) async {
    await LocalNotifications.cancel(id);
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
            title: const Text(
              'Settings',
              style: AppFonts.h10,
            ),
            centerTitle: true,
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        reminder.title,
                        style: AppFonts.h8,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      contentPadding:
                                          EdgeInsetsDirectional.only(
                                              start: 10.0),
                                    ),
                                    // style: TextStyle( decoration: TextDecoration.none),
                                    onTap: () =>
                                        _showTimePicker(context, index, box),
                                    controller: dateTimeControllers[index],
                                  ),
                                ),
                                  
                                //       SizedBox(
                                //   width: MediaQuery.of(context).size.width * 0.5,
                                // ),
                                Switch(
                                  value: reminder.active,
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
                          )),
                    ]),
                  );
                },
              ),
        );
      },
    );
  }
}
