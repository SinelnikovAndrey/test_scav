import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/history_data.dart';
import 'package:test_scav/utils/app_colors.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';

// ... Your ItemData, PlaceData models, and other pages ...

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
  DateTime _selectedDateTime = DateTime.now();
  String? _selectedImagePath; // Path to the selected image
  late Box<HistoryData> placeBox; // Declare placeBox
  final _imagePicker = ImagePicker();
  String? _imageUrl;

  HistoryData? item;
  late Box<HistoryData> historyBox;
  late HistoryData itemData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    placeBox = Hive.box<HistoryData>(historyBoxName);
    _placeNameController.text = widget.placeData.placeName;
    _placeDescriptionController.text = widget.placeData.placeDescription;
    _placePhotoUrlController.text = widget.placeData.placePhotoUrl ?? '';
    // itemData = historyBox.get(widget.itemId.toString()) ??
    //     HistoryData(
    //       photoUrl: '',
    //       id: '',
    //       placeName: '',
    //       saveDateTime: DateTime.now(),
    //       itemName: '',
    //       fetchDateTime: DateTime.now(),
    //       placeDescription: '',
    //     );
    // _selectedDateTime = widget.placeData.saveDateTime;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadItemData();
  //   historyBox = Hive.box<HistoryData>(historyBoxName);

  // }

  @override
  void dispose() {
    _placeNameController.dispose();
    _placeDescriptionController.dispose();
    _placePhotoUrlController.dispose();
    // placeBox.close(); // Close the box when disposing
    super.dispose();
  }

  Future<void> _updatePlace() async {
    if (_formKey.currentState!.validate()) {
      final updatedPlaceData = HistoryData(
          id: widget.placeData.id,
          placeName: _placeNameController.text.trim(),
          // saveDateTime: _selectedDateTime,
          photoUrl: widget.placeData.photoUrl,
          placeDescription: _placeDescriptionController.text.trim(),
          itemName: widget.placeData.itemName,
          itemColor: widget.placeData.itemColor,
          itemForm: widget.placeData.itemForm,
          itemGroup: widget.placeData.itemGroup,
          itemDescription: widget.placeData.itemDescription,
          placePhotoUrl: _selectedImagePath ?? widget.placeData.placePhotoUrl,
          saveDateTime: _selectedDateTime,
          fetchDateTime: _selectedDateTime);

      final placeBox = await Hive.openBox<HistoryData>(historyBoxName);
      await placeBox.put(widget.placeData.id.toString(), updatedPlaceData);

      // Trigger a rebuild of the widget to reflect the changes
      setState(() {});
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeData.itemName),
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
                              controller: _placeNameController,
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
