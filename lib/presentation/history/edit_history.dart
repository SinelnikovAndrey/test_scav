import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';
import 'package:test_scav/widgets/left_button.dart';


class EditHistoryPage extends StatefulWidget {
  final HistoryData placeData;

  const EditHistoryPage({Key? key, required this.placeData}) : super(key: key);

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
  String? _selectedImagePath; 
  late Box<HistoryData> historyBox; 
  String? _imageUrl;

  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _dateTimeController = TextEditingController();

  HistoryData? item;
  late HistoryData itemData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    historyBox = Hive.box<HistoryData>(historyBoxName);
    _placeNameController.text = widget.placeData.placeName;
    _placeDescriptionController.text = widget.placeData.placeDescription;
    _placePhotoUrlController.text = widget.placeData.placePhotoUrl ?? '';
    _selectedDate = widget.placeData.saveDateTime;

     _updateDateTimeController();
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
        _selectedImage();
      });
    }
  }

void _updateDateTimeController() {
    _dateTimeController.text = DateFormat('dd/MM/yy HH:mm').format(_selectedDateTime);
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
        initialTime: TimeOfDay(hour: _selectedDateTime.hour, minute: _selectedDateTime.minute),
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

  Future<void> _selectedImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
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
      final updatedPlaceData = HistoryData(
          id: widget.placeData.id,
          placeName: _placeNameController.text.trim(),
          photoUrl: widget.placeData.photoUrl,
          placeDescription: _placeDescriptionController.text.trim(),
          itemName: widget.placeData.itemName,
          itemColor: widget.placeData.itemColor,
          itemForm: widget.placeData.itemForm,
          itemGroup: widget.placeData.itemGroup,
          itemDescription: widget.placeData.itemDescription,
          placePhotoUrl: _selectedImagePath ?? widget.placeData.placePhotoUrl,
          saveDateTime: widget.placeData.saveDateTime ,
          fetchDateTime: widget.placeData.fetchDateTime 
          );

      final placeBox = await Hive.openBox<HistoryData>(historyBoxName);
      await placeBox.put(widget.placeData.id.toString(), updatedPlaceData);

      Navigator.pop(context);
    }
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.placeData.itemName, style: AppFonts.h10,),
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

                if (widget.placeData.photoUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(widget.placeData.photoUrl! ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover),
                      ),


                const SizedBox(height: 20.0),

                /////////FORM------FORM////////
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
                  GestureDetector(
                  onTap: _selectedImage,
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
