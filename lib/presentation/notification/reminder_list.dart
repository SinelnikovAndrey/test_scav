import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/note_state.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/left_button.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:uuid/uuid.dart';


class ReminderList extends StatefulWidget {
  const ReminderList({super.key});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
   final List<TextEditingController> dateTimeControllers = [];
  final devNotificationService = NotificationService();
  final scheduledNotifications = <int>{}; 

  @override
  void initState() {
    super.initState();
    devNotificationService.init();
    NotificationService.onClickNotification.listen((String? payload) {
      if (payload != null) {
        Navigator.pushNamed(context, '/notificationPage');
      }
    });
  }
  Future<void> _showTimePicker(BuildContext context, int index, Box<Reminder> box) async {
    final reminder = box.getAt(index);
    if (reminder == null) {
      return; 
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(reminder.dateTime),
    );

    if (picked != null) {
      final newDateTime = DateTime(
        reminder.dateTime.year,
        reminder.dateTime.month,
        reminder.dateTime.day,
        picked.hour,
        picked.minute,
      );

      final updatedReminder = reminder.copyWith(dateTime: newDateTime); 
      await box.putAt(index, updatedReminder);
      setState(() {
        dateTimeControllers[index].text = DateFormat('HH:mm').format(newDateTime);
      });

      _toggleReminderNotification(context, updatedReminder);
    }
  }



  Future<void> _toggleReminderNotification(
    BuildContext context,
    Reminder updatedReminder,
  ) async {
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    final notificationState = Provider.of<NotificationState>(context, listen: false);


    final existingId = devNotificationService.generateUniqueId(updatedReminder.id);
    if(notificationState.scheduledNotificationIds.contains(existingId)){
       await notificationService.cancelNotification(existingId);
       notificationState.removeScheduledNotificationId(existingId);
    }
      

    if (updatedReminder.active) {
        await _scheduleNotification(context, updatedReminder);
    }
  }




  Future<void> _scheduleNotification(BuildContext context, Reminder reminder) async {
    final id = devNotificationService.generateUniqueId(reminder.id);
    final notificationService = Provider.of<NotificationService>(context, listen: false);
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
      Provider.of<NotificationState>(context, listen: false).addScheduledNotificationId(id);
      print('Scheduled notification for ${reminder.title}, ID: $id');
    } catch (e) {
      print('Error scheduling notification: $e');
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
            title: const Text('Settings', style: AppFonts.h10,),
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
              : Column(
                children: [
                  const SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 359,
                                    height:
                                        52,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.60,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 10.0),
                                              ),
                                              onTap: () => _showTimePicker(
                                                  context, index, box),
                                              controller:
                                                  dateTimeControllers[index],
                                              maxLines: 1,
                                            ),
                                          ),
                                          // Switch(
                                          //   value: reminder.active,
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       reminder.active = value;
                                          //     });
                                          //     _scheduleReminderNotification(
                                          //         context, reminder, reminder.id);
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                ],
              ),
        );
      },
    );
  }



  //  Future<void> _updateReminderNotification(
  //     BuildContext context, Reminder reminder) async {
  //   final devNotificationState =
  //       Provider.of<DevNotificationState>(context, listen: false);
  //   //Cancel existing notification if it exists
  //   final existingNotificationId =
  //       devNotificationService.generateUniqueId(reminder.id);

  //   if (scheduledNotifications.contains(existingNotificationId)) {
  //     try {
  //       await devNotificationService.cancelNotification(existingNotificationId);
  //       scheduledNotifications.remove(existingNotificationId);
  //       devNotificationState
  //           .removeScheduledNotificationId(existingNotificationId);
  //     } catch (e) {
  //       print("Error canceling notification: $e");
  //     }
  //   }

  //   // Schedule the updated notification
  //   // _scheduleReminderNotification(context, reminder, reminder.id);
  // }


  // Future<void> _updateRemindersActiveState(
  //     BuildContext context, bool value) async {
  //   final notificationService = Provider.of<DevNNotificationService>(context, listen: false);
  //   final box = Hive.box<Reminder>(reminderBoxName);
  //   final reminders = box.values.toList();
  //   for (final reminder in reminders) {
  //     try {
  //       reminder.active = value; // Correct logic: directly set active state
  //       await reminder.save();
  //       final notificationService = Provider.of<DevNNotificationService>(context, listen: false);
  //       if (reminder.active) {
  //         notificationService.scheduleNotification(
  //           reminder.id,
  //           reminder.title,
  //           reminder.body ?? '',
  //           reminder.dateTime,
  //           TimeOfDay.fromDateTime(reminder.dateTime),
  //           reminder.id.toString(),
  //           'daily',
  //           null,
  //         );
  //       } else {
  //         notificationService.cancelNotification(reminder.id);
  //       }
  //     } catch (e) {
  //       print('Error updating reminder ${reminder.id}: $e');
  //       // ... (Error handling remains the same) ...
  //     }
  //   }
  // }

}

