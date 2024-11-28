import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsCopy extends StatefulWidget {
  const SettingsCopy({super.key});

  @override
  State<SettingsCopy> createState() => _SettingsCopyState();
}

class _SettingsCopyState extends State<SettingsCopy> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _notificationPermissionRequested = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ... other settings ...

              const SizedBox(height: 20),
              Text(
                  'Schedule Daily Notification at: ${DateFormat.jm().format(DateTime(2024, 1, 1, _selectedTime.hour, _selectedTime.minute))}'),
              ElevatedButton(
                onPressed: () =>
                    _selectTime(context), // Correctly call _selectTime
                child: const Text('Select Time'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_notificationPermissionRequested) {
                    await NotificationService.requestPermission();
                    _notificationPermissionRequested = true;
                  }
                  if (_formKey.currentState!.validate()) {
                    try {
                      // ... (rest of the onPressed function remains the same) ...
                    } catch (e) {
                      // ... (rest of the onPressed function remains the same) ...
                    }
                  }
                },
                child: const Text('Schedule Daily Notification'),
              ),

              ElevatedButton(
                onPressed: () async {
                  await NotificationService.cancelDailyNotification(
                      0); //Again, consider improving the ID generation
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Daily Notification Cancelled')));
                },
                child: const Text('Cancel Daily Notification'),
              ),

              // ... other settings ...
            ],
          ),
        ),
      ),
    );
  }
}
