
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:test_scav/models/history_data.dart';
import 'package:test_scav/models/item_data.dart';

void registerAdapters() {

  Hive.registerAdapter(ItemDataAdapter()); 
  Hive.registerAdapter(HistoryDataAdapter()); 
}

class ItemDataAdapter extends TypeAdapter<ItemData> {
  @override
  final int typeId = 0; 

  @override
  ItemData read(BinaryReader reader) {
    return ItemData(
      id: reader.readString(),
      name: reader.readString(),
      color: reader.readString(),
      form: reader.readString(),
      group: reader.readString(),
      description: reader.readString(),
      photoUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemData obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.color); 
    writer.writeString(obj.form); 
    writer.writeString(obj.group);
    writer.writeString(obj.description);
    writer.writeString(obj.photoUrl ?? '');
  }
}



class HistoryDataAdapter extends TypeAdapter<HistoryData> {
  @override
  final int typeId = 1;

  @override
  HistoryData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryData(
      id: fields[0] as String,
      placeName: fields[1] as String,
      saveDateTime: fields[2] as DateTime,
      itemName: fields[3] as String,
      placeDescription: fields[4] as String,
      photoUrl: fields[5] as String?,
      fetchDateTime: fields[6] as DateTime,
      itemColor: fields[7] as String?,
      itemForm: fields[8] as String?,
      itemGroup: fields[9] as String?,
      itemDescription: fields[10] as String?,
      placePhotoUrl: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryData obj) {
    writer.writeByte(12); 
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.placeName);
    writer.writeByte(2);
    writer.write(obj.saveDateTime);
    writer.writeByte(3);
    writer.write(obj.itemName);
    writer.writeByte(4);
    writer.write(obj.placeDescription);
    writer.writeByte(5);
    writer.write(obj.photoUrl);
    writer.writeByte(6);
    writer.write(obj.fetchDateTime);
    writer.writeByte(7);
    writer.write(obj.itemColor);
    writer.writeByte(8);
    writer.write(obj.itemForm);
    writer.writeByte(9);
    writer.write(obj.itemGroup);
    writer.writeByte(10);
    writer.write(obj.itemDescription);
    writer.writeByte(11);
    writer.write(obj.placePhotoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// class HistoryDataAdapter extends TypeAdapter<HistoryData> {
//   @override
//   final int typeId = 1;

//   @override
//   HistoryData read(BinaryReader reader) {
//     return HistoryData(
//        id: reader.readString(),
//        placeName: reader.readString(),
//        saveDateTime: reader.readString(),
//        placeDescription: reader.readString(),
//        photoUrl: reader.readString(),
//        itemName: reader.readString(),
//        itemColor: reader.readString(),
//        itemForm: reader.readString(),
//        itemGroup: reader.readString(),
//        itemDescription: reader.readString(),
//        placePhotoUrl: reader.readString(),
//        fetchDate: reader.readString(),
//        fetchTime: reader.readString(),
//           );
//   }

//      @override
//   void write(BinaryWriter writer, HistoryData obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.placeName);
//     writer.write(obj.saveDateTime);

//     writer.writeString(obj.placeDescription ?? '');
//     writer.writeString(obj.photoUrl ?? '');
//     writer.writeString(obj.itemName);
//     writer.writeString(obj.itemColor ?? '');
//     writer.writeString(obj.itemForm ?? '');
//     writer.writeString(obj.itemGroup ?? '');
//     writer.writeString(obj.itemDescription ?? '');
//     writer.writeString(obj.placePhotoUrl ?? '');
//     writer.writeString(obj.fetchDate);
//     writer.writeString(obj.fetchTime);
//   }

// }

// class HistoryDataAdapter extends TypeAdapter<HistoryData> {
//   @override
//   final int typeId = 1;

//   @override
//   HistoryData read(BinaryReader reader) {
//     try {
//       final id = reader.readString();
//       final placeName = reader.readString();
//       final saveDateTime = reader.read() ; 
//       final placeDescription = reader.readString();
//       final photoUrl = reader.readString();
//       final itemName = reader.readString();
//       final itemColor = reader.readString();
//       final itemForm = reader.readString();
//       final itemGroup = reader.readString();
//       final itemDescription = reader.readString();
//       final placePhotoUrl = reader.readString();
//       final fetchDate = reader.readString();
//       final fetchTime = reader.readString();
      

//       // Convert saveTimeString back to TimeOfDay
//       final saveTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(saveTimeString));
//       final saveDate = DateTime.fromMillisecondsSinceEpoch(saveDateMillis);
//       return HistoryData(
//         id: id,
//         placeName: placeName,
//         itemName: itemName,
//         placeDescription: placeDescription,
//         photoUrl: photoUrl,
//         itemColor: itemColor,
//         itemForm: itemForm,
//         itemGroup: itemGroup,
//         itemDescription: itemDescription,
//         placePhotoUrl: placePhotoUrl, 
//         saveDateTime: saveDateTime, 
//         fetchDate: fetchDate, 
//         fetchTime: fetchTime,
//       );
//     } on RangeError catch (e) {
//       print('RangeError in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('RangeError');
//     } on HiveError catch (e) {
//       print('HiveError in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('HiveError');
//     } catch (e) {
//       print('Unexpected error in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('UnexpectedError');
//     }
//   }

//   @override
//   void write(BinaryWriter writer, HistoryData obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.placeName);
//     writer.write(obj.saveDateTime);

//     writer.writeString(obj.placeDescription ?? '');
//     writer.writeString(obj.photoUrl ?? '');
//     writer.writeString(obj.itemName);
//     writer.writeString(obj.itemColor ?? '');
//     writer.writeString(obj.itemForm ?? '');
//     writer.writeString(obj.itemGroup ?? '');
//     writer.writeString(obj.itemDescription ?? '');
//     writer.writeString(obj.placePhotoUrl ?? '');
//     writer.writeString(obj.fetchDate);
//     writer.writeString(obj.fetchTime);
//   }


// }


// class HistoryDataAdapter extends TypeAdapter<HistoryData> {
//   @override
//   final int typeId = 1;

//   @override
//   HistoryData read(BinaryReader reader) {
//     try {
//       final id = reader.readString();
//       final placeName = reader.readString();
//       final saveDateMillis = reader.readInt();
//       final saveTimeString = reader.readString();
//       final placeDescription = reader.readString(); // Now it should work
//       final photoUrl = reader.readString();
//       final itemName = reader.readString();
//       final itemColor = reader.readString();
//       final itemForm = reader.readString();
//       final itemGroup = reader.readString();
//       final itemDescription = reader.readString();
//       final placePhotoUrl = reader.readString();

//       // Convert saveTimeString back to TimeOfDay
//       final saveTime = TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(saveTimeString));
//       final saveDate = DateTime.fromMillisecondsSinceEpoch(saveDateMillis);

//       return HistoryData(
//         id: id,
//         placeName: placeName,
//         fetchDateTime: ,
//         itemName: itemName,
//         placeDescription: placeDescription,
//         photoUrl: photoUrl,
//         itemColor: itemColor,
//         itemForm: itemForm,
//         itemGroup: itemGroup,
//         itemDescription: itemDescription,
//         placePhotoUrl: placePhotoUrl,
//       );
//     } on RangeError catch (e) {
//       print('RangeError in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('RangeError');
//     } on HiveError catch (e) {
//       print('HiveError in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('HiveError');
//     } catch (e) {
//       print('Unexpected error in HistoryDataAdapter.read(): $e');
//       return _createDefaultHistoryData('UnexpectedError');
//     }
//   }

//   @override
//   void write(BinaryWriter writer, HistoryData obj) {
//     writer.writeInt(obj.id);
//     writer.writeString(obj.placeName);
//     writer.writeInt(obj.saveDate.millisecondsSinceEpoch); 
//     writer.writeString(DateFormat('HH:mm').format(obj.saveTime)); 
//     writer.writeString(obj.placeDescription ?? '');
//     writer.writeString(obj.photoUrl ?? '');
//     writer.writeString(obj.itemName);
//     writer.writeString(obj.itemColor ?? '');
//     writer.writeString(obj.itemForm ?? '');
//     writer.writeString(obj.itemGroup ?? '');
//     writer.writeString(obj.itemDescription ?? '');
//     writer.writeString(obj.placePhotoUrl ?? '');
//   }

//   HistoryData _createDefaultHistoryData(String errorMessage) {
//     return HistoryData(
//       id: -1,
//       placeName: 'Error',
//       saveDateTime: DateTime.now(),
//       itemName: 'Error',
//       placeDescription: errorMessage, saveDate: null, saveTime: null,
//     );
//   }
// }

