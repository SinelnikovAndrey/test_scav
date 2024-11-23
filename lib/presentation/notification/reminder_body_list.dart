import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/presentation/notification/notification.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/app_router.dart';
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
    LocalNotifications.init();
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
            title: const Text('Notification', style: AppFonts.h10,),
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
                child: LeftButton(
                  onTap: () {
                          Navigator.of(context).pushNamed(AppRouter.reminderItemRoute);
                        },
                  icon: Icons.edit,
                  iconColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.black12,
                ),
              ),
            ],
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
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.circular(20)),
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child:  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(reminder.body, style: AppFonts.h7,)),
                                        //  SizedBox(
                                        //   width: MediaQuery.of(context).size.width * 0.3,
                                        //  ),
                                        Text(reminder.formattedReminderTime, style: AppFonts.h7,),
                                   
                                      ],
                                    ),
                                  )),
                                                const SizedBox(height: 10,)
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



