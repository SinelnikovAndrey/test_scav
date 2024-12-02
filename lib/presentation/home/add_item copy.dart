import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:uuid/uuid.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final ValueNotifier<File?> _imageNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _selectedGroupNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _selectedColorNotifier = ValueNotifier("Grey");

  final _formKey = GlobalKey<FormState>();
  String? selectedReminderTitle;

  final _nameController = TextEditingController();
  final _formController = TextEditingController();
  final _descriptionController = TextEditingController();

  final picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  String _generateId() {
    var random = Random();
    var randomNumber = random.nextInt(1000000);
    return 'item_$randomNumber';
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    _imageNotifier.value = pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<List<String>> _fetchReminderTitles() async {
    final box = await Hive.openBox<Reminder>(reminderBoxName);
    return box.values.map((reminder) => reminder.title).toList();
  }

  Future<void> _addItem() async {
  if (_formKey.currentState!.validate()) {
    //Check for empty strings
    if (_nameController.text.trim().isEmpty || _formController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }
    try {
      final relativePath = await FileUtils.saveImage(_imageFile!);
      if (relativePath == null) {
        throw Exception('Image save failed');
      }

      final box = Hive.box<ItemData>(itemBoxName);
      final newItem = ItemData(
        id: const Uuid().v4(), //Use UUID for better ID generation
        relativeImagePath: relativePath,
        name: _nameController.text.trim(),
        color: selectedColorName,
        form: _formController.text.trim(),
        group: selectedReminderTitle ?? '',
        description: _descriptionController.text.trim(),
      );

      await box.put(newItem.id, newItem);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')));
      Navigator.pop(context, newItem);
    } on HiveError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hive error: ${e.message}')));
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding item: $e')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown error: $e')));
    }
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Add Item',
            style: AppFonts.h10,
          ),
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
        body: FutureBuilder<List<String>>(
            future: _fetchReminderTitles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading groups: ${snapshot.error}'));
              } else {
                final reminderTitles = snapshot.data ?? []; // Handle empty case
                return ValueListenableBuilder<String?>(
                    valueListenable: _selectedGroupNotifier,
                    builder: (context, selectedGroup, child) {
                      print("selectedGroup: $selectedGroup");
                      print("reminderTitles length: ${reminderTitles.length}");
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                ValueListenableBuilder<File?>(
                                  valueListenable: _imageNotifier,
                                  builder: (context, imageFile, child) {
                                    return GestureDetector(
                                      onTap: _pickImage,
                                      child: imageFile != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppColors.gray,
                                              ),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: Image.file(imageFile,
                                                  height: 200,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppColors.darkBorderGray,
                                              ),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              child: const Center(
                                                child: Text(
                                                  '+Add Photo',
                                                  style: AppFonts.h6,
                                                ),
                                              ),
                                            ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Name',
                                        style: AppFonts.h6,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 5),
                                                child: TextFormField(
                                                  controller: _nameController,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: 'Add name',
                                                          hintStyle: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.grey,
                                                          )),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter a name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 10.0),
                                      ValueListenableBuilder<String?>(
                                        valueListenable: _selectedColorNotifier,
                                        builder:
                                            (context, selectedColor, child) {
                                          return Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.68,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 5),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    decoration: const InputDecoration(
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    value: selectedColor,
                                                    items: colorMap.keys
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e)))
                                                        .toList(),
                                                    onChanged: (value) =>
                                                        _selectedColorNotifier
                                                            .value = value,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              ColorBox(
                                                  color:
                                                      colorMap[selectedColor] ??
                                                          Colors.grey),
                                            ],
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 10.0),
                                      const Text(
                                        'Format',
                                        style: AppFonts.h6,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 5),
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a format';
                                                }
                                                return null;
                                              },
                                            ),
                                          )),
                                      const SizedBox(height: 10.0),

                                      // Group selection with ValueListenableBuilder
                                      const Text(
                                        'Group',
                                        style: AppFonts.h6,
                                      ),
                                      Row( // Or a Column depending on your layout requirements.
  children: [
    Expanded(
      child: DropdownButtonFormField<String>(
        value: selectedGroup,
        decoration: const InputDecoration(
          hintText: 'Select Group',
        ),
        items: reminderTitles.map((title) {
          return DropdownMenuItem<String>(
            value: title,
            child: Text(title),
          );
        }).toList(),
        onChanged: (value) {
          _selectedGroupNotifier.value = value;
        },
        validator: (value) => value == null ? 'Please select a group' : null,
      ),
    ),
  ],
),

                                      const SizedBox(height: 10.0),
                                      const Text(
                                        'Description',
                                        style: AppFonts.h6,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 5),
                                            child: TextFormField(
                                              controller:
                                                  _descriptionController,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Add description',
                                                  hintStyle: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  )),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a description';
                                                }
                                                return null;
                                              },
                                            ),
                                          )),
                                      const SizedBox(height: 40.0),
                                    ]),
                                DefaultButton(
                                  text: 'Add',
                                  onTap: _addItem,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }));
  }
}
