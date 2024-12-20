import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
import 'package:test_scav/utils/assets.dart';
import 'package:test_scav/widgets/left_button.dart';

class ReminderBodyList extends StatefulWidget {
  const ReminderBodyList({super.key});

  @override
  State<ReminderBodyList> createState() => _ReminderBodyListState();
}

class _ReminderBodyListState extends State<ReminderBodyList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Reminder>>(
      valueListenable: Hive.box<Reminder>(reminderBoxName).listenable(),
      builder: (context, box, child) {
        final reminders = box.values.toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notification',
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
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.grey!,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRouter.reminderItemRoute);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        child: SvgPicture.asset(
                          SvgAssets.alarmClock,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: reminders.isEmpty
              ? const Center(child: Text('No reminders found'))
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: 72,
                                  width: 382,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // const SizedBox(width: 20,),
                                        SizedBox(
                                          width: 250,
                                          child: Text(reminder.body,
                                              style: AppFonts.h7,
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        // const SizedBox(width: 30,),
                                        const Spacer(),
                                        Text(
                                          reminder.formattedReminderTime,
                                          style: AppFonts.h5,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
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
}
