import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _formController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _imagePicker = ImagePicker();
  File? _imageFile;

  List<Reminder> _reminders = []; 
  String? _selectedReminderTitle;

  late final Box<ItemData> _itemBox;

  @override
  void initState() {
    super.initState();

    _itemBox = Hive.box<ItemData>(itemBoxName);
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminderBox = await Hive.openBox<Reminder>(reminderBoxName);
    setState(() {
      _reminders = reminderBox.values.toList();
    });
  }

  String _generateId() {
    var random = Random();
    var randomNumber = random.nextInt(1000000);
    return 'item_$randomNumber';
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        final fileSizeInBytes = await File(pickedFile.path).length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 10) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: const Text(
                  'Image file is too large (over 10MB). Please select a smaller image.')));
          return;
        }

        setState(() {
          _imageFile = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selection cancelled.')),
        );
      }
    } catch (e) {
      debugPrintStack(label: 'Image picker error:');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error picking image: $e'),
      ));
    }
  }

  Future<void> _addFile() async {
    if (_formKey.currentState!.validate()) {
      // Input validation
      if (_nameController.text.trim().isEmpty ||
          _formController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty ||
          _selectedReminderTitle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')));
        return;
      }

      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image')));
        return;
      }

      try {
        final relativePath = await FileUtils.saveImage(_imageFile!);
        if (relativePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error saving image')));
          return;
        }

        final newItem = ItemData(
          id: const Uuid().v4(),
          relativeImagePath: relativePath,
          name: _nameController.text.trim(),
          color: selectedColorName,
          form: _formController.text.trim(),
          group: _selectedReminderTitle ?? '',
          description: _descriptionController.text.trim(),
        );

        await _itemBox.put(newItem.id, newItem);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully!')));
        Navigator.pop(context, newItem); 
      } on HiveError catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hive error: ${e.message}')));
      } on Exception catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding item: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _imageFile != null
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.darkBorderGray,
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Image.file(
                              _imageFile!,
                              // height: 200,
                              // width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.darkBorderGray,
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const Center(
                                child: Text(
                              '+ Add Photo',
                              style: AppFonts.h6,
                            )),
                          ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Name',
                    style: AppFonts.h6,
                  ),
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
                              controller: _nameController,
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
                  const SizedBox(height: 10.0),
                  const Text(
                    'Color',
                    style: AppFonts.h6,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: DropdownButton<String>(
                            value: selectedColorName,
                            onChanged: (String? newColorName) {
                              setState(() {
                                selectedColorName = newColorName ?? 'Grey';
                              });
                            },
                            items: colorMap.keys.map((colorName) {
                              return DropdownMenuItem<String>(
                                value: colorName,
                                child: Text(colorName),
                              );
                            }).toList(),
                            underline: Container(),
                            menuWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ColorBox(
                          color: colorMap[selectedColorName] ?? Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Format',
                    style: AppFonts.h6,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: TextFormField(
                          controller: _formController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add format',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a format';
                            }
                            return null;
                          },
                        ),
                      )),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Group',
                    style: AppFonts.h6,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: _reminders.isEmpty
                          ? const Center(
                              child: Text(
                                  'Create groups on My Items Page'))
                          : DropdownButtonFormField<String>(
                              value: _selectedReminderTitle,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              hint: const Text('Select group'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedReminderTitle = newValue;
                                });
                              },
                              items: _reminders.map((reminder) {
                                return DropdownMenuItem<String>(
                                  value: reminder.title,
                                  child: Text(reminder.title),
                                );
                              }).toList(),
                             
                            ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Description',
                    style: AppFonts.h6,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add description',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      )),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                ]),
                DefaultButton(
                  text: 'Add',
                  onTap: _addFile,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
