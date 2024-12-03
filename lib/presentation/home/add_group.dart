import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:uuid/uuid.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late Box<Reminder> reminderBox;
  int _nextId = 1;

  @override
  void initState() {
    super.initState();
    _loadNextId();
  }

  Future<void> _loadNextId() async {
    reminderBox = await Hive.openBox<Reminder>(reminderBoxName); 
    setState(() {
      _nextId = reminderBox.length + 1;
    });
  }

  Future<void> _addGroup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newReminder = Reminder(
          body: "Check your ${_titleController.text.trim()} items",
          id: _nextId++, 
          title: _titleController.text.trim(),
          dateTime: DateTime.now(),
          active: false,
        );
        await reminderBox.add(newReminder); 
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group added successfully!')));
        Navigator.pop(context);
      } on HiveError catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hive Error: ${e.message}')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group', style: AppFonts.h10),
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.9,
          child: DefaultButton(
            text: "Save",
            onTap: _addGroup,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name', style: AppFonts.h6),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Add name',
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
