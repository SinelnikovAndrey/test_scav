import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

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

    bool _isFormValid = false; 


  List<Reminder> _reminders = [];
  String? _selectedReminderTitle;

  @override
  void initState() {
    super.initState();
    _selectedReminderTitle = widget.itemData.group;
    _itemBox = Hive.box<ItemData>(itemBoxName);
    _nameController.text = widget.itemData.name;
    _colorController.text = widget.itemData.color;
    _formController.text = widget.itemData.form;
    _groupController.text = widget.itemData.group;
    _descriptionController.text = widget.itemData.description;
    _relativeImagePath = widget.itemData.relativeImagePath;
    _loadReminders();
    // _updateFormValidity();
  }


  //  void _updateFormValidity() {
  //   setState(() {
  //     _isFormValid = _nameController.text.isNotEmpty &&
  //          _formController.text.isNotEmpty &&
  //          _descriptionController.text.isNotEmpty &&
  //          _selectedReminderTitle != null &&
  //          selectedColorName.isNotEmpty;
  //   });
  // }


  Future<void> _loadReminders() async {
    final reminderBox = await Hive.openBox<Reminder>(reminderBoxName);
    setState(() {
      _reminders = reminderBox.values.toList();
    });
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

  Future<void> _editFile() async {
    if (
      _formKey.currentState!.validate()
      ) {
      if (_nameController.text.trim().isEmpty ||
          _formController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty ||
          _selectedReminderTitle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')));
        return;
      }

      try {
        String? newRelativePath; 

        if (_imageFile != null) {
          newRelativePath = await FileUtils.saveImage(_imageFile!);
          if (newRelativePath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error saving image')));
            return;
          }
        }

        final editedItem = widget.itemData.copyWith(
          name: _nameController.text.trim(),
          color: selectedColorName,
          form: _formController.text.trim(),
          group: _selectedReminderTitle ?? '',
          description: _descriptionController.text.trim(),
          relativeImagePath: newRelativePath ??
              widget.itemData.relativeImagePath, 
        );

        await _itemBox.put(widget.itemData.id, editedItem);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')));
        Navigator.pop(context, editedItem); 
      } on HiveError catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hive error: ${e.message}')));
      } on Exception catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding item: $e')));
      }
    }
  }

  Widget _buildImageWidget(File imageFile, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.gray,
      ),
      height: 382,
      width: 382,
      child: Image.file(
        imageFile,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddPhotoOverlay(BuildContext context) {
    return Positioned.fill(
      child: Container(
        height: 382,
                            width: 382,
        color: Colors.black.withOpacity(0.5), 
        child: const Center(
          child: Text(
            '+ Add New',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
        height: 382,
        width: 382,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.darkBorderGray,
        ),
        child: const Center(child: Text('+ Add Photo')));
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return const SizedBox(
      height: 382,
      width: 382,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(child: Text('Error: $error'));
  }

  Future<File?> _getImageFile(String relativePath) async {
    try {
      final imagePath = await FileUtils.getFullImagePath(relativePath);
      final file = File(imagePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null; 
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ItemData>>(
      valueListenable:  Hive.box<ItemData>(itemBoxName).listenable(),
      builder: (context, itemBox, child) {
        final items = itemBox.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // The image or placeholder
                        _imageFile != null
                            ? _buildImageWidget(_imageFile!, context)
                            : widget.itemData.relativeImagePath!.isNotEmpty
                                ? FutureBuilder<File?>(
                                    future: _getImageFile(
                                        widget.itemData.relativeImagePath!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return _buildLoadingWidget(context);
                                      } else if (snapshot.hasError) {
                                        return _buildErrorWidget(
                                            snapshot.error.toString());
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return _buildImageWidget(
                                            snapshot.data!, context);
                                      } else {
                                        return _buildPlaceholder(context);
                                      }
                                    },
                                  )
                                : _buildPlaceholder(context),

                        if (_imageFile == null &&
                            widget.itemData.relativeImagePath!.isNotEmpty)
                          _buildAddPhotoOverlay(context),
                      ],
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
                      height: 52,
                      width: 382,
                      child: Column(
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            
                            child: TextFormField(
                              controller: _nameController,
                              
                              // onChanged: (_) => _updateFormValidity(),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Add name',
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  )),
                          
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Color',
                    style: AppFonts.h6,
                  ),
                  SizedBox(
                    width: 382,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20)),
                          height: 52,
                          width: 280,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: DropdownButton<String>(
                              value: selectedColorName,
                              onChanged: (String? newColorName) {
                                setState(() {
                                  selectedColorName =
                                      newColorName ?? widget.itemData.color;
                                      //  _updateFormValidity();
                                });
                              },
                              items: colorMap.keys.map((colorName) {
                                return DropdownMenuItem<String>(
                                  value: colorName,
                                  child: Text(colorName),
                                );
                              }).toList(),
                              underline: Container(),
                              menuWidth: 280,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ColorBox(
                            height: 52,
                            width: 52,
                            color: colorMap[selectedColorName] ?? Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Form',
                    style: AppFonts.h6,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      height: 52,
                      width: 382,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: TextFormField(
                          controller: _formController,
                          // onChanged: (_) => _updateFormValidity(),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add form',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                       
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
                    height: 52,
                    width: 382,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: _reminders.isEmpty
                          ? const Center(child: Text('Loading reminders...'))
                          : DropdownButtonFormField<String>(
                              value: _selectedReminderTitle ??
                                  widget.itemData.group, 
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              hint: const Text(
                                  'Select Reminder'), 
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedReminderTitle = newValue;
                                  // _updateFormValidity();
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
                      height: 52,
                      width: 382,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          // onChanged: (_) => _updateFormValidity(),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add description',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                        
                        ),
                      )),
                  const SizedBox(height: 20.0),
                ]),
                DefaultButton(
                  text: 'Save',
                  onTap: _editFile,
                  // isEnabled: _isFormValid,
                )
              ],
            ),
          ),
        ),
      ),
    );
  });}
}
