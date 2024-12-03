import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/my_app.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';
import 'package:path/path.dart' as p;

class EditHistoryPage extends StatefulWidget {
  final HistoryData placeData;

  const EditHistoryPage({
    Key? key,
    required this.placeData,
  }) : super(key: key);

  @override
  State<EditHistoryPage> createState() => _EditHistoryPageState();
}

class _EditHistoryPageState extends State<EditHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  final _placeDescriptionController = TextEditingController();

  final _placePhotoUrlController = TextEditingController();

  late final Box<HistoryData> historyBox;

  final _imagePicker = ImagePicker();

  File? _imageFile;

  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _dateTimeController = TextEditingController();

  // HistoryData item;
  late HistoryData itemData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _openHistoryBox();
    _placeNameController.text = widget.placeData.placeName;
    _placeDescriptionController.text = widget.placeData.placeDescription;
    _placePhotoUrlController.text = widget.placeData.placePhotoUrl;

    _updateDateTimeController();
    _setInitialDateTime();
  }

  void _setInitialDateTime() {
    if (widget.placeData.saveDateTime != null) {
      _selectedDateTime = widget.placeData.saveDateTime;
      _dateTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.placeData.saveDateTime!);
    }
  }

  Future<void> _openHistoryBox() async {
    try {
      historyBox = await Hive.openBox<HistoryData>(historyBoxName);
      setState(() {}); 
    } catch (e) {
      print('Error opening history box: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error opening history box: $e'),
      ));
    }
  }




  void _updateDateTimeController() {
    _dateTimeController.text =
        DateFormat('dd/MM/yy HH:mm').format(_selectedDateTime);
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: _selectedDateTime.hour, minute: _selectedDateTime.minute),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = selectedDateTime;
          _updateDateTimeController();
        });
      }
    }
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

  @override
  void dispose() {
    _placeNameController.dispose();
    _placeDescriptionController.dispose();
    _placePhotoUrlController.dispose();
    
    super.dispose();
  }

  Future<void> _updatePlace() async {
    if (_formKey.currentState!.validate()) {
      if (_placeNameController.text.trim().isEmpty ||
              _placeDescriptionController.text.trim().isEmpty
          ) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')));
        return;
      }

      try {
        String? newPlaceRelativePath; 

        if (_imageFile != null) {
          newPlaceRelativePath = await FileUtils.saveImage(_imageFile!);
          if (newPlaceRelativePath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error saving image')));
            return;
          }
        }
        final updatedPlaceData = widget.placeData.copyWith(
          id: widget.placeData.id,
          placeName: _placeNameController.text.trim(),
          relativeImagePath: widget.placeData.relativeImagePath,
          placeDescription: _placeDescriptionController.text.trim(),
          itemName: widget.placeData.itemName,
          itemColor: widget.placeData.itemColor,
          itemForm: widget.placeData.itemForm,
          itemGroup: widget.placeData.itemGroup,
          itemDescription: widget.placeData.itemDescription,
          placePhotoUrl: newPlaceRelativePath ?? widget.placeData.placePhotoUrl,
          saveDateTime: _selectedDateTime ?? widget.placeData.saveDateTime,
          fetchDateTime: _selectedDateTime ?? widget.placeData.fetchDateTime,
        );

        await historyBox.put(widget.placeData.id, updatedPlaceData);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')));
        Navigator.pop(context, updatedPlaceData);
      } on HiveError catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Hive error: ${e.message}')));
      } on Exception catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding item: $e')));
      }
    }
  }


    //Helper functions
Widget _buildImageWidget(File imageFile, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.gray,
    ),
    height: MediaQuery.of(context).size.height * 0.4,
    width: MediaQuery.of(context).size.width * 0.9,
    child: Image.file(
      imageFile,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  );
}

Widget _buildAddPhotoOverlay(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return Positioned.fill(
    child: Container(
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
  final mediaQuery = MediaQuery.of(context);
  return Container(
      height: mediaQuery.size.height * 0.4,
      width: mediaQuery.size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.darkBorderGray,
      ),
      child: const Center(child: Text('+ Add Photo')));
}

Widget _buildLoadingWidget(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return Container(
    height: mediaQuery.size.height * 0.4,
    width: mediaQuery.size.width * 0.9,
    child: const Center(child: CircularProgressIndicator()),
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
    final appDocumentsDirPath =
        Provider.of<AppData>(context).appDocumentsDirPath;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.placeData.itemName,
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.placeData.relativeImagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(p.join(
                          appDocumentsDirPath,
                          widget.placeData
                              .relativeImagePath!)), 
                    ),
                  ),

                const SizedBox(height: 20.0),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Date and Time',
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
                        child: TextField(
                          onTap: () => _selectDateAndTime(context),
                          controller: _dateTimeController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'date and time',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              )),
                        ),
                      )),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Location',
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
                          controller: _placeNameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'edit place',
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
                          controller: _placeDescriptionController,
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
                  ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _imageFile != null
                            ? _buildImageWidget(_imageFile!, context)
                            : widget.placeData.placePhotoUrl!.isNotEmpty
                                ? FutureBuilder<File?>(
                    future: _getImageFile(widget.placeData.placePhotoUrl!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingWidget(context);
                      } else if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error.toString());
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return _buildImageWidget(snapshot.data!, context);
                      } else {
                        return _buildPlaceholder(context);
                      }
                    },
                  )
                                : _buildPlaceholder(context),
                  
                        if (_imageFile == null && widget.placeData.placePhotoUrl!.isNotEmpty)
                          _buildAddPhotoOverlay(context),
                      ],
                    ),
                  ),
                ),
                  const SizedBox(height: 20.0),
                ]),

                DefaultButton(
                  text: 'Save',
                  onTap: _updatePlace,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

