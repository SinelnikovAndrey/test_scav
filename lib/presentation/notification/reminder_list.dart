import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/note_state.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';


class OldReminderList extends StatefulWidget {
  const OldReminderList({super.key});

  @override
  State<OldReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<OldReminderList> {
  final List<TextEditingController> dateTimeControllers = [];
  final notificationService = NNotificationService(); 

  @override
  void initState() {
    super.initState();
    notificationService.init();
    NNotificationService.onClickNotification.listen((String? payload) {
      if (payload != null) {
        Navigator.pushNamed(context, '/notificationPage');
      }
    });
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

      final updatedReminder = box
          .getAt(index)!
          .copyWith(dateTime: newDateTime, active: true);
      await box.putAt(index, updatedReminder);

      setState(() {
        dateTimeControllers[index].text =
            DateFormat('HH:mm').format(newDateTime);
      });

      _toggleReminderNotification(context, updatedReminder);
    }
  }

  Future<void> _toggleReminderNotification(
      BuildContext context, Reminder reminder) async {
    final notificationState = Provider.of<NotificationState>(context, listen: false);
    if (reminder.active) {
      final id = notificationService.generateUniqueId(reminder.id);
      try {
        await notificationService.scheduleNotification(
          id,
          'Daily Scavenger',
          '🔔 Check your ${reminder.title} items',
          reminder.dateTime,
          TimeOfDay.fromDateTime(reminder.dateTime),
          'dailyReminder',
          'daily',
          null,
        );
        notificationState.addScheduledNotificationId(id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Notification for ${reminder.title} scheduled!'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error scheduling notification: $e'),
        ));
      }
    } else {
      notificationService.cancelNotification(reminder.id);
      notificationState.removeScheduledNotificationId(reminder.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notification for ${reminder.title} cancelled!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationState(),
      child: Consumer<NotificationState>(
        builder: (context, notificationState, child) {
          return _buildReminderList(context, notificationState);
        },
      ),
    );
  }

  Widget _buildReminderList(
      BuildContext context, NotificationState notificationState) {
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
                    return SizedBox( 
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.60,
                              child: Text(
                                reminder.title,
                                style: AppFonts.h8,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.60,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            focusedBorder:
                                                InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsetsDirectional
                                                .only(start: 10.0),
                                          ),
                                          onTap: () => _showTimePicker(
                                              context, index, box),
                                          controller:
                                              dateTimeControllers[index],
                                          maxLines: 1,
                                        ),
                                      ),
                                      Switch(
                                        value: reminder.active,
                                        onChanged: (value) {
                                          setState(() {
                                            reminder.active = value;
                                          });
                                          _toggleReminderNotification(
                                              context, reminder);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

