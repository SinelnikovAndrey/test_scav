import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';


class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _formController = TextEditingController();
  final _groupController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _imagePicker = ImagePicker();
  String? _imageUrl;

 

  @override
  void initState() {
    super.initState();
  }


  String _generateId() {
    var random = Random();
    var randomNumber = random.nextInt(1000000);
    return 'item_$randomNumber';
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );
    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path; // Store image path locally
      });
    }
  }


  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
     
      });
      try {
        final box = await Hive.openBox<ItemData>(itemBoxName);
        final id = _generateId();
        final newItem = ItemData(
          id: id,
          photoUrl: _imageUrl,
          name: _nameController.text.trim(), 
          color: selectedColorName, 
          form: _formController.text.trim(), 
          group: _groupController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        await box.put(id.toString(), newItem);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
                  text: 'Add',
                  onTap: _addItem,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  final Color color;

  const ColorBox({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
