import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/note_state.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_colors.dart';

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

   Future<void> _updateRemindersActiveState(
      BuildContext context, bool value) async {
    final box = Hive.box<Reminder>(reminderBoxName);
    final reminders = box.values.toList();
    for (final reminder in reminders) {
      try {
        reminder.active = value;
        await reminder.save();
        final notificationService = Provider.of<NotificationService>(context, listen: false);
        if (reminder.active) {
          notificationService.scheduleNotification(
            reminder.id,
            reminder.title,
            reminder.body ,
            reminder.dateTime,
            TimeOfDay.fromDateTime(reminder.dateTime),
            reminder.id.toString(),
            'daily',
            null,
          );
        } else {
          notificationService.cancelNotification(reminder.id);
        }
      } catch (e) {
        print('Error updating reminder ${reminder.id}: $e');

      }
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
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
        child: Column(children: [
          Column(children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                final Uri url = Uri.parse('https://telegram.org/privacy/ru');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                  height: 60,
                  width: 382,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.shield),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Privacy policy',
                          style: AppFonts.h6,
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.reminderBodyRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 60,
                width: 382,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Notification',
                        style: AppFonts.h6,
                      ),
                      const SizedBox(
                        width: 105,
                      ),
                      Consumer<NotificationState>(
                        builder: (context, notificationState, child) {
                          return CupertinoSwitch(
                            value: notificationState.globalActive,
                            activeColor: AppColors.primary2,
                            thumbColor: AppColors.primary,
                            onChanged: (value) {
                              notificationState.globalActive = value;
                              _updateRemindersActiveState(context, value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ]),
      ),
    );
  }
}
