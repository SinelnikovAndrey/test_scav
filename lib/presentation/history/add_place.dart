import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_scav/main.dart';
import 'package:test_scav/models/history_data.dart';
import 'dart:math';

import 'package:test_scav/models/item_data.dart';
import 'package:test_scav/utils/app_fonts.dart';
import 'package:test_scav/widgets/default_button.dart';

class AddPlacePage extends StatefulWidget {
  final String itemId;

  const AddPlacePage({
    super.key,
    required this.itemId,
  });

  static MaterialPageRoute materialPageRoute({
    required String itemId,
  }) =>
      MaterialPageRoute(
          builder: (context) => AddPlacePage(
                itemId: itemId,
              ));

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>(); // Remains final
  final _placeNameController = TextEditingController(); // Remains final
  late Box<ItemData> itemBox;
  late ItemData itemData;

  @override
  void initState() {
    super.initState();
    itemBox = Hive.box<ItemData>(itemBoxName);
    itemData = itemBox.get(widget.itemId.toString()) ??
        ItemData(
            name: '',
            photoUrl: '',
            id: '',
            color: '',
            form: '',
            group: '',
            description: '');
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }

  String _generateId() {
    var random = Random();
    var randomNumber = random.nextInt(1000000);
    return 'item_$randomNumber';
  }

  Future<void> _addPlace() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      try {
        final placeId = _generateId();
        final placeData = HistoryData(
          id: placeId,
          placeName: _placeNameController.text.trim(),
          saveDateTime: DateTime.now(),
          photoUrl: itemData.photoUrl,
          itemName: itemData.name,
          itemColor: itemData.color,
          itemForm: itemData.form,
          itemGroup: itemData.group,
          itemDescription: itemData.description,
          fetchDateTime: DateTime.now(), placeDescription: '',
        );

        final placeBox = await Hive.openBox<HistoryData>(historyBoxName);
        await placeBox.put(placeId.toString(), placeData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Place added history successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      controller: _placeNameController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add place',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a place';
                        }
                        return null;
                      },
                    ),
                  )),
              const SizedBox(height: 32.0),
              DefaultButton(
                text: 'Add',
                onTap: _addPlace,
              )
            ],
          ),
        ),
      ),
    );
  }
}