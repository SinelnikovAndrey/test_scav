
import 'package:hive/hive.dart';
import 'package:test_scav/data/models/history_data.dart';
import 'package:test_scav/data/models/item_data.dart';
import 'package:test_scav/data/models/reminder/reminder.dart';

void registerAdapters() {

  Hive.registerAdapter(ItemDataAdapter()); 
  Hive.registerAdapter(HistoryDataAdapter()); 
  Hive.registerAdapter(ReminderAdapter()); 
}

class ItemDataAdapter extends TypeAdapter<ItemData> {
  @override
  final int typeId = 2; 

  @override
  ItemData read(BinaryReader reader) {
    return ItemData(
      id: reader.readString(),
      name: reader.readString(),
      color: reader.readString(),
      form: reader.readString(),
      group: reader.readString(),
      description: reader.readString(),
      relativeImagePath: reader.readString(),
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
    writer.writeString(obj.relativeImagePath ?? '');
  }
}



class HistoryDataAdapter extends TypeAdapter<HistoryData> {
  @override
  final int typeId = 3;

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
      relativeImagePath: fields[5] as String,
      saveTime: fields[6] as DateTime,
      itemColor: fields[7] as String?,
      itemForm: fields[8] as String?,
      itemGroup: fields[9] as String?,
      itemDescription: fields[10] as String?,
      placePhotoUrl: fields[11] as String,
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
    writer.write(obj.relativeImagePath);
    writer.writeByte(6);
    writer.write(obj.saveTime);
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

// class ReminderAdapter extends TypeAdapter<Reminder> {
//   @override
//   final int typeId = 5;

//   @override
//   Reminder read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Reminder(
//       title: fields[0] as String,
//       dateTime: fields[1] as DateTime,
//       active: fields[2] as bool,
//       id: fields[3] as int,
//       body: fields[4] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Reminder obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.title)
//       ..writeByte(1)
//       ..write(obj.dateTime)
//       ..writeByte(2)
//       ..write(obj.active)
//       ..writeByte(3)
//       ..write(obj.id)
//       ..writeByte(4)
//       ..write(obj.body);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ReminderAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }