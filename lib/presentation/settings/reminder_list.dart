import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/settings/notification_service.dart';
import 'package:test_scav/presentation/settings/widgets/date_time_selector.dart';

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
  final NotificationService _notificationService = NotificationService();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

    final List<TextEditingController> dateTimeControllers = [];
  final uuid = const Uuid();
  final Map<int, bool> reminderNotificationStates = {};

  @override
  void initState() {
    super.initState();
   NotificationService().initialize();
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
          _scheduleNotification(updatedReminder.id, updatedReminder);
        }
      });
    }
  }


  

  Future<void> _cancelNotification(int id) async {
    await _notificationService.cancel(id);
    setState(() {
      reminderNotificationStates.remove(id);
    });
  }

  Future<void> _scheduleNotification(int id, Reminder reminder) async {
    final DateTime scheduleDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduleDateTime.isBefore(DateTime.now())) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select future date and time"),
          backgroundColor: Colors.redAccent,
        ));

        return;
      }

      await _notificationService.scheduleNotification(scheduleDateTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Notification Scheduale for ${scheduleDateTime.toString()}"),
          backgroundColor: Colors.greenAccent,
        ));

        return;
      }
    }
  }


  void _updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: _notificationService.showInstantNotification,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text("Send Instant")),
            const SizedBox(
              height: 40,
            ),
            DateTimeSelector(
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateTimeChanged: _updateDateTime
                ),
                const SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //     onPressed: _scheduleNotification,
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.amber,
            //         padding: const EdgeInsets.symmetric(vertical: 12)),
            //     child: const Text("Send Schedule")),


                Expanded(
                  child: reminders.isEmpty
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
                                        MediaQuery.of(context).size.width * 0.50,
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
                                        await _scheduleNotification(
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
                ),
       ] )));
      },
    );
  }
}

