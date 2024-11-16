
import 'package:hive/hive.dart';
import 'package:test_scav/models/item_data.dart';

void registerAdapters() {

  Hive.registerAdapter(ItemDataAdapter()); 
  // Hive.registerAdapter(HistoryDataAdapter()); 
}

class ItemDataAdapter extends TypeAdapter<ItemData> {
  @override
  final int typeId = 0; // This is the same typeId as in @HiveType

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


// class HistoryDataAdapter extends TypeAdapter<HistoryData> {
//   @override
//   final int typeId = 1; 
  
//    @override
//   void write(BinaryWriter writer, HistoryData obj) {
//     writer.writeString(obj.id);
//     writer.writeString(obj.placeName);
//     writer.write(obj.saveDateTime);
//     writer.writeString(obj.photoUrl ?? ''); // Write photoUrl (null to empty string)
//     writer.writeString(obj.placePhotoUrl ?? ''); // Write photoUrl (null to empty string)
//     writer.writeString(obj.itemName);
//     writer.writeString(obj.fetchDate); // Write photoUrl (null to empty string)
//     writer.writeString(obj.fetchTime);
    
//   }

//   @override
//   HistoryData read(BinaryReader reader) {
//     final id = reader.readString();
//     final placeName = reader.readString();
//     final saveDateTime = reader.read() ; 
//     final photoUrl = reader.readString();
//     final itemName = reader.readString();
//     final placePhotoUrl = reader.readString();
//     final fetchDate = reader.readString();
//     final fetchTime = reader.readString();

//     return HistoryData(
//       id: id,
//       placeName: placeName,
//       saveDateTime: saveDateTime,
//       photoUrl: photoUrl, 
//       itemName: itemName, 
//       placePhotoUrl: placePhotoUrl, 
//       fetchDate: fetchDate, 
//       fetchTime: fetchTime, 
//     );
//   } 

 
// }

