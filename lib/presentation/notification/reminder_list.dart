import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/presentation/notification/reminder/reminder.dart';
import 'package:test_scav/presentation/notification/notification.dart';
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
        // Reschedule notification if it was already scheduled
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
      reminderNotificationStates.remove(id); // Update notification state
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
          appBar: AppBar(title: const Text('Reminders')),
          body: reminders.isEmpty
              ? const Center(child: Text('No reminders found'))
              : ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    //Remove unnecessary reminderNotificationStates
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
                                .active, // Get active status from the Reminder object
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
                              setState(() {}); // Update UI to reflect change
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to AddReminderPage (Implement navigation logic here)
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





































//// work VERSION 3
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/presentation/new_notification.dart/ModelDataBase/TableReminder.dart';

// class ReminderList extends StatefulWidget {
//   const ReminderList({super.key});

//   @override
//   State<ReminderList> createState() => _ReminderListState();
// }

// class _ReminderListState extends State<ReminderList> {
//   final List<TextEditingController> dateTimeControllers = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     for (final controller in dateTimeControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }


//   Future<void> _showTimePicker(BuildContext context, int index, Box<Reminder> box) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(box.getAt(index)!.dateTime),
//     );
//     if (picked != null) {
//       final newDateTime = DateTime(
//         box.getAt(index)!.dateTime.year,
//         box.getAt(index)!.dateTime.month,
//         box.getAt(index)!.dateTime.day,
//         picked.hour,
//         picked.minute,
//       );

//       final updatedReminder = box.getAt(index)!.copyWith(dateTime: newDateTime);
//       box.putAt(index, updatedReminder);
//       setState(() {
//           dateTimeControllers[index].text = DateFormat('HH:mm').format(newDateTime);
//       });
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Box<Reminder>>(
//       valueListenable: Hive.box<Reminder>(reminderBoxName).listenable(),
//       builder: (context, box, child) {
//         final reminders = box.values.toList();
//         if (dateTimeControllers.length != reminders.length) {
//           dateTimeControllers.clear();
//           for (var reminder in reminders) {
//             dateTimeControllers.add(TextEditingController(
//               text: DateFormat('HH:mm').format(reminder.dateTime),
//             ));
//           }
//         }
//         return Scaffold(
//           appBar: AppBar(title: const Text('Reminders')),
//           body: reminders.isEmpty
//               ? const Center(child: Text('No reminders found'))
//               : ListView.builder(
//                   itemCount: reminders.length,
//                   itemBuilder: (context, index) {
//                     final reminder = reminders[index];
//                     return ListTile(
//                       title: Text(reminder.title),
//                       subtitle: TextField(
//                         controller: dateTimeControllers[index],
//                         readOnly: true,
//                         onTap: () => _showTimePicker(context, index, box),
//                         decoration: const InputDecoration(
//                             hintText: 'Tap to set time'),
//                       ),
//                     );
//                   },
//                 ),
//         );
//       },
//     );
//   }
// }
// extension ReminderExtension on Reminder {
//   Reminder copyWith({String? title, DateTime? dateTime, bool? active, int? id}) {
//     return Reminder(
//       title: title ?? this.title,
//       dateTime: dateTime ?? this.dateTime,
//       active: active ?? this.active,
//       id: id ?? this.id,
//     );
//   }
// }

/// VERSION 2
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:intl/intl.dart';
// import 'package:test_scav/presentation/new_notification.dart/ModelDataBase/TableReminder.dart';


// class ReminderList extends StatefulWidget {
//   const ReminderList({super.key});

//   @override
//   State<ReminderList> createState() => _ReminderListState();
// }

// class _ReminderListState extends State<ReminderList> {
//   List<Reminder> reminders = [];
//   final List<TextEditingController> dateTimeControllers = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadReminders(); // Load reminders immediately
//   }

//   Future<void> _loadReminders() async {
//     final box = Hive.box<Reminder>('remindersBox'); // Use the correct box name

//     // IMPORTANT:  Check if the box exists before accessing its values
//     if (box.isNotEmpty) {
//       setState(() {
//         reminders = box.values.toList();
//         for (var reminder in reminders) {
//           dateTimeControllers.add(TextEditingController(
//             text: DateFormat('HH:mm').format(reminder.dateTime),
//           ));
//         }
//       });
//     }
//   }


//   Future<void> _showTimePicker(BuildContext context, int index) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(reminders[index].dateTime),
//     );
//     if (picked != null) {
//       final newDateTime = DateTime(
//         reminders[index].dateTime.year,
//         reminders[index].dateTime.month,
//         reminders[index].dateTime.day,
//         picked.hour,
//         picked.minute,
//       );

//       setState(() {
//         reminders[index] = reminders[index].copyWith(dateTime: newDateTime);
//         dateTimeControllers[index].text = DateFormat('HH:mm').format(newDateTime);
//         Hive.box<Reminder>('remindersBox').putAt(index, reminders[index]);
//       });
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Reminders')),
//       body: reminders.isEmpty
//           ? const Center(child: Text('No reminders found'))
//           : ListView.builder(
//         itemCount: reminders.length,
//         itemBuilder: (context, index) {
//           final reminder = reminders[index];
//           return ListTile(
//             title: Text(reminder.title),
//             subtitle: TextField(
//               controller: dateTimeControllers[index],
//               readOnly: true,
//               onTap: () => _showTimePicker(context, index),
//               decoration: const InputDecoration(hintText: 'Tap to set time'),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     for (final controller in dateTimeControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
// }

// extension ReminderExtension on Reminder {
//   Reminder copyWith({String? title, DateTime? dateTime, bool? active, int? id}) {
//     return Reminder(
//       title: title ?? this.title,
//       dateTime: dateTime ?? this.dateTime,
//       active: active ?? this.active,
//       id: id ?? this.id,
//     );
//   }
// }





///   VERSION 1
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:test_scav/main.dart';
// import 'package:test_scav/presentation/new_notification.dart/ModelDataBase/TableReminder.dart';


// class ReminderList extends StatefulWidget {
//   const ReminderList({super.key,});

//   @override
//   State<ReminderList> createState() => _ReminderListState();
// }

// class _ReminderListState extends State<ReminderList> {
//   late Box<Reminder> reminderBox;
//   List<Reminder> _reminders = [];
//   final List<TextEditingController> _dateTimeControllers = [];
  

//   @override
//   void initState() {
//     super.initState();
//     _initHive();
//   }

//   Future<void> _initHive() async {
//     reminderBox = await Hive.openBox<Reminder>(reminderBoxName);
//     _reminders = reminderBox.values.toList();
//     for (final reminder in _reminders) {
//       _dateTimeControllers.add(
//         TextEditingController(text: DateFormat('HH:mm').format(reminder.dateTime)),
//       );
//     }
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     for (final controller in _dateTimeControllers) {
//       controller.dispose();
//     }
//     reminderBox.close();
//     super.dispose();
//   }


//   Future<void> _showTimePicker(BuildContext context, int index) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(_reminders[index].dateTime),
//     );
//     if (picked != null) {
//       final newDateTime = DateTime(
//         _reminders[index].dateTime.year,
//         _reminders[index].dateTime.month,
//         _reminders[index].dateTime.day,
//         picked.hour,
//         picked.minute,
//       );
//       setState(() {
//         _reminders[index] = _reminders[index].copyWith(dateTime: newDateTime);
//         _dateTimeControllers[index].text = DateFormat('HH:mm').format(newDateTime);
//         reminderBox.putAt(index, _reminders[index]); // Update in Hive
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Reminders')),
//       body: ValueListenableBuilder(
//         valueListenable: reminderBox.listenable(),
//         builder: (context, Box<Reminder> box, widget) {
//           final currentItems = box.values.toList(); 
//           if (currentItems.isEmpty) {
//             return const Center(child: Text('No reminder found'));
//           } else {
//             return ListView.builder(
//           itemCount: _reminders.length,
//           itemBuilder: (context, index) {
//             final reminder = _reminders[index];
//             return ListTile(
//               title: Text(reminder.title),
//               subtitle: TextField(
//                 controller: _dateTimeControllers[index],
//                 readOnly: true,
//                 onTap: () => _showTimePicker(context, index),
//                 decoration: const InputDecoration(hintText: 'Tap to set time'),
//               ),
//             );
//           },
//         );}}
//       ),
//     );
//   }
// }


// extension ReminderExtension on Reminder {
//   Reminder copyWith({String? title, DateTime? dateTime, bool? active, int? id}) {
//     return Reminder(
//       title: title ?? this.title,
//       dateTime: dateTime ?? this.dateTime,
//       active: active ?? this.active,
//       id: id ?? this.id,
//     );
//   }
// }