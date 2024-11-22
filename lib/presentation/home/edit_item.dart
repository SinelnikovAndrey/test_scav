import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/color_box.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';

class EditItemPage extends StatefulWidget {
  final ItemData itemData;

  const EditItemPage({super.key, required this.itemData});

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
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.itemData.name;
    _colorController.text = widget.itemData.name;
    _formController.text = widget.itemData.form;
    _groupController.text = widget.itemData.group;
    _descriptionController.text = widget.itemData.description;
    
    _imageUrl = widget.itemData.photoUrl;
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery, 
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final box = await Hive.openBox<ItemData>(itemBoxName);

      final updatedItem = ItemData(
        id: widget.itemData.id,
        name: _nameController.text.trim(),
        color: selectedColorName,
        form: _formController.text.trim(),
        group: _groupController.text.trim(),
        description: _descriptionController.text.trim(),
        photoUrl: _imageUrl,
      );
      await box.put(widget.itemData.id.toString(), updatedItem);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item', style: AppFonts.h10),
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
      body:  SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GestureDetector(
                  onTap: _selectImage,
                  child: _imageUrl != null
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.gray,
                          ),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Image.file(File(_imageUrl!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover),
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
                                horizontal: 20.0, vertical: 10),
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
                                selectedColorName = newColorName!;
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
                      ColorBox(color: colorMap[selectedColorName]!),
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
                              hintText: 'Add form',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a form';
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
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: TextFormField(
                          controller: _groupController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add group',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a group';
                            }
                            return null;
                          },
                        ),
                      )),
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
                  text: 'Save',
                  onTap: _saveChanges,
                )
              ],
            ),
          ),
        ),
      ),
    
    );
  }
}
