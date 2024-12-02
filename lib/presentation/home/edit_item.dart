import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:uuid/uuid.dart';

class EditItemPage extends StatefulWidget {
  final ItemData itemData;
  final ValueNotifier<ItemData> itemDataNotifier;

  const EditItemPage(
      {super.key, required this.itemData, required this.itemDataNotifier});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _formController = TextEditingController();
  final _groupController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _imagePicker = ImagePicker();
  File? _imageFile;
  String? _relativeImagePath;
  late final Box<ItemData> _itemBox;

  String? _imageUrl;

   List<Reminder> _reminders = []; // List to hold reminders
  String? _selectedReminderTitle;

  @override
  void initState() {
    super.initState();
    _itemBox = Hive.box<ItemData>(itemBoxName); 
    _nameController.text = widget.itemData.name;
    _colorController.text = widget.itemData.color;
    _formController.text = widget.itemData.form;
    _groupController.text = widget.itemData.group;
    _descriptionController.text = widget.itemData.description;
    _relativeImagePath = widget.itemData.relativeImagePath;
    _loadReminders(); 
  }


  Future<void> _loadReminders() async {
    final reminderBox = await Hive.openBox<Reminder>(reminderBoxName);
    setState(() {
      _reminders = reminderBox.values.toList();
    });
  }


  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path); //Set the image
        });
      } else {
        // Handle the case where the user cancels the image selection.
      }
    } on Exception catch (e) {
      //Show error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image picking error: $e')));
    }
  }

 Future<void> _editFile() async {
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

      // Check if an image has been selected
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image')));
        return;
      }

      try {
      String? newRelativePath; //Declare here

      if (_imageFile != null) {
          newRelativePath = await FileUtils.saveImage(_imageFile!);
          if (newRelativePath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error saving image')));
            return;
          }
      }

        final editedItem = widget.itemData.copyWith( // Use copyWith for immutability
        name: _nameController.text.trim(),
        color: selectedColorName,
        form: _formController.text.trim(),
        group: _selectedReminderTitle ?? '',
        description: _descriptionController.text.trim(),
        relativeImagePath: newRelativePath ?? widget.itemData.relativeImagePath, //Keep old path if not changed
      );

        await _itemBox.put(widget.itemData.id, editedItem); 

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')));
        Navigator.pop(context, editedItem); // Return the new item
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
                GestureDetector(
  onTap: _pickImage,
  child: _imageFile != null
      ? Container( // Show the new image if it's selected
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.gray,
          ),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.file(
            _imageFile!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        )
      : FutureBuilder<String>( // Show existing image otherwise
          future: FileUtils.getFullImagePath(widget.itemData.relativeImagePath!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.file(File(snapshot.data!));
            } else if (snapshot.hasError) {
              return Container(
                  // ... (placeholder for error as before) ...
                  );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
),

                const SizedBox(height: 20.0),

                /////////FORM------FORM////////
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
                                horizontal: 20.0, vertical: 5),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Add name',
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  )
                                  ),
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
                                selectedColorName = newColorName ?? widget.itemData.color;
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
                      ColorBox(color: colorMap[selectedColorName] ?? Colors.grey),
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: _reminders.isEmpty
                ? const Center(child: Text('Loading reminders...')) //Show while loading.
                : DropdownButtonFormField<String>(
                    value: _selectedReminderTitle,
                    decoration: const InputDecoration(border: InputBorder.none),
                    hint:  Text(widget.itemData.group),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a reminder';
                      }
                      return null;
                    },
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
                  onTap: _editFile,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
