import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/utils/file_utils.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';

class EditHistoryPage extends StatefulWidget {
  final HistoryData placeData;
  // final ValueNotifier<HistoryData> placeDataNotifier;

  const EditHistoryPage(
      {Key? key, required this.placeData, })
      : super(key: key);

  @override
  State<EditHistoryPage> createState() => _EditHistoryPageState();
}

class _EditHistoryPageState extends State<EditHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  final _placeDescriptionController = TextEditingController();

  final _placePhotoUrlController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late final Box<HistoryData> historyBox;
  
  final _imagePicker = ImagePicker();
  // File? _imageUrl;
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
    // historyBox = Hive.box<HistoryData>(historyBoxName);
    _placeNameController.text = widget.placeData.placeName;
    _placeDescriptionController.text = widget.placeData.placeDescription;
    _placePhotoUrlController.text = widget.placeData.placePhotoUrl;
    _selectedDate = widget.placeData.saveDateTime;

    _updateDateTimeController();
  }

  Future<void> _openHistoryBox() async {
  try {
    historyBox = await Hive.openBox<HistoryData>(historyBoxName);
    setState(() {}); // Rebuild the widget after the box is opened.
  } catch (e) {
    // Handle errors opening the box, such as a missing box.
    print('Error opening history box: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error opening history box: $e'),
    ));
  }
}

  void _updateTimeController() {
    _timeController.text = _selectedTime.format(context);
  }

  void _updateDateController() {
    _dateController.text = DateFormat('dd/MM/yy HH:mm').format(_selectedDate);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;

        _updateDateTimeController();
        // _selectedImage();
      });
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

  @override
  void dispose() {
    _placeNameController.dispose();
    _placeDescriptionController.dispose();
    _placePhotoUrlController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _updatePlace() async {
    if (_formKey.currentState!.validate()) {
      // Input validation
      if (_placeNameController.text.trim().isEmpty ||
          _placeDescriptionController.text.trim().isEmpty ||
          _dateTimeController.text.trim().isEmpty 
          ) {
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
      String? newPlaceRelativePath; //Declare here

      if (_imageFile != null) {
          newPlaceRelativePath = await FileUtils.saveImage(_imageFile!);
          if (newPlaceRelativePath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error saving image')));
            return;
          }
      }
      final updatedPlaceData =  widget.placeData.copyWith( 
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
        saveDateTime: widget.placeData.saveDateTime,
        fetchDateTime: widget.placeData.fetchDateTime,
      );

      await historyBox.put(widget.placeData.id , updatedPlaceData);

      
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')));
        Navigator.pop(context, updatedPlaceData); // Return the new item
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FutureBuilder<String>(
                          future: FileUtils.getFullImagePath(
                            widget.placeData.relativeImagePath,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.file(
                                File(
                                  snapshot.data!,
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                              );
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      /////////FORM------FORM////////
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date and Time',
                              style: AppFonts.h6,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(20)),
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
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
                            GestureDetector(
                              onTap: _pickImage,
                              child: _imageFile != null
                                  ? Container(
                                      // Show the new image if it's selected
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.gray,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Image.file(
                                        _imageFile!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : FutureBuilder<String>(
                                      // Show existing image otherwise
                                      future: FileUtils.getFullImagePath(
                                          widget.placeData.placePhotoUrl!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Image.file(
                                              File(snapshot.data!));
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
                          ]),

                      DefaultButton(
                        text: 'Add',
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

