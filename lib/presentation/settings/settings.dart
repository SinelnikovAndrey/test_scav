import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _rating = 3.0;

  final InAppReview inAppReview = InAppReview.instance;

  // final ValueNotifier<bool> _allNotificationsEnabled =
  //     ValueNotifier(false);

  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _notificationPermissionRequested = false;
  final _formKey = GlobalKey<FormState>();

  bool _notificationScheduled = false; //This line was missing
  int _notificationId = 0;

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

  final _allNotificationsEnabled = ValueNotifier<bool>(false);
  int _notificationIdCounter = 0;
  List<int> _scheduledNotificationIds =
      []; //Keep track of scheduled notification IDs

  int _generateUniqueId() {
    _notificationIdCounter++;
    return _notificationIdCounter;
  }

  Future<void> _updateAllNotifications(bool enabled) async {
    final box = await Hive.openBox<Reminder>(reminderBoxName);
    final reminders = box.values.toList();
    await box.clear();

    _scheduledNotificationIds.forEach(NotificationService.cancelNotification);
    _scheduledNotificationIds.clear();

    for (final reminder in reminders) {
      final updatedReminder = reminder.copyWith(active: enabled);
      await box.add(updatedReminder);
      if (enabled && updatedReminder.active) {
        final id = _generateUniqueId();
        final timeOfDay = TimeOfDay.fromDateTime(
            updatedReminder.dateTime); // Extract TimeOfDay
        await NotificationService.scheduleDailyNotification(
            id,
            updatedReminder.title,
            updatedReminder.body,
            timeOfDay,
            id.toString());
        _scheduledNotificationIds.add(id);
      }
    }

    _allNotificationsEnabled.value = enabled;
    String message =
        enabled ? 'All notifications enabled' : 'All notifications disabled';
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
  }

  Future<void> _toggleNotification(BuildContext context) async {
    setState(() {
      _notificationScheduled = !_notificationScheduled;
    });

    if (_notificationScheduled) {
      if (!_notificationPermissionRequested ||
          await NotificationService.checkPermission() == false) {
        final permissionGranted = await NotificationService.requestPermission();
        if (!permissionGranted) {
          setState(() => _notificationScheduled = false);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification permission denied.')));
          return;
        }
        _notificationPermissionRequested = true;
      }
      _notificationId = _generateUniqueId();
      try {
        await NotificationService.scheduleDailyNotification(
            _notificationId,
            'Daily Reminder',
            'Your daily reminder!',
            _selectedTime,
            'daily_reminder');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification Scheduled!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _notificationScheduled = false);
      }
    } else {
      await NotificationService.cancelDailyNotification(_notificationId);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily Notification Cancelled')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings', style: AppFonts.h10),
          centerTitle: true,
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.9,
              child: DefaultButton(
                text: 'Rate Us',
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text("Rate Us", style: AppFonts.h8),
                                  const SizedBox(height: 10.0),
                                  RatingBar.builder(
                                    initialRating: _rating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  DefaultButton(
                                      text: 'Submitt',
                                      onTap: () {
                                        inAppReview.openStoreListing(
                                            appStoreId:
                                                'com.google.android.youtube');
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            )),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                InkWell(
                  onTap: () async {
                    final Uri url =
                        Uri.parse('https://telegram.org/privacy/ru');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            const Text(
                              'Privacy policy',
                              style: AppFonts.h6,
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _allNotificationsEnabled,
                  builder: (context, enabled, child) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRouter.reminderBodyRoute);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.90,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.shield),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    const Text(
                                      'Notification',
                                      style: AppFonts.h6,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Switch(
                                        value: _notificationScheduled,
                                        onChanged: (value) =>
                                            _toggleNotification(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 12),
            ],
          ),
        ));
  }
}
