import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

@immutable
class HistoryData {
  final String id;
  final String placeName;
  final DateTime saveDateTime;
  final DateTime fetchDateTime;
  final String itemName;
  final String placeDescription;
  final String? photoUrl;
  final String? itemColor;
  final String? itemForm;
  final String? itemGroup;
  final String? itemDescription;
  final String? placePhotoUrl;

  HistoryData({
    required this.id,
    required this.placeName,
    required this.saveDateTime,
    required this.itemName,
    required this.placeDescription,
    this.photoUrl,
    required this.fetchDateTime,
    this.itemColor,
    this.itemForm,
    this.itemGroup,
    this.itemDescription,
    this.placePhotoUrl,
  });

  String get formattedFetchDate => DateFormat('dd.MM.yy').format(fetchDateTime);
  String get formattedFetchTime => DateFormat('HH:mm').format(fetchDateTime);

  HistoryData copyWith({
    String? id,
    String? placeName,
    DateTime? saveDateTime,
    DateTime? fetchDateTime,
    String? itemName,
    String? placeDescription,
    String? photoUrl,
    String? itemColor,
    String? itemForm,
    String? itemGroup,
    String? itemDescription,
    String? placePhotoUrl,
  }) {
    return HistoryData(
      id: id ?? this.id,
      placeName: placeName ?? this.placeName,
      saveDateTime: saveDateTime ?? this.saveDateTime,
      itemName: itemName ?? this.itemName,
      placeDescription: placeDescription ?? this.placeDescription,
      photoUrl: photoUrl ?? this.photoUrl,
      fetchDateTime: fetchDateTime ?? this.fetchDateTime,
      itemColor: itemColor ?? this.itemColor,
      itemForm: itemForm ?? this.itemForm,
      itemGroup: itemGroup ?? this.itemGroup,
      itemDescription: itemDescription ?? this.itemDescription,
      placePhotoUrl: placePhotoUrl ?? this.placePhotoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'placeName': placeName,
      'saveDateTime': saveDateTime.toIso8601String(),
      'fetchDateTime': fetchDateTime.toIso8601String(),
      'itemName': itemName,
      'placeDescription': placeDescription,
      'photoUrl': photoUrl,
      'itemColor': itemColor,
      'itemForm': itemForm,
      'itemGroup': itemGroup,
      'itemDescription': itemDescription,
      'placePhotoUrl': placePhotoUrl,
    };
  }

  factory HistoryData.fromMap(Map<String, dynamic> map) {
    return HistoryData(
      id: map['id'] as String,
      placeName: map['placeName'] as String,
      saveDateTime: DateTime.parse(map['saveDateTime'] as String),
      itemName: map['itemName'] as String,
      placeDescription: map['placeDescription'] as String,
      photoUrl: map['photoUrl'] as String?,
      fetchDateTime: DateTime.parse(map['fetchDateTime'] as String),
      itemColor: map['itemColor'] as String?,
      itemForm: map['itemForm'] as String?,
      itemGroup: map['itemGroup'] as String?,
      itemDescription: map['itemDescription'] as String?,
      placePhotoUrl: map['placePhotoUrl'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryData.fromJson(String source) =>
      HistoryData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryData{id: $id, placeName: $placeName, saveDateTime: $saveDateTime, fetchDateTime: $fetchDateTime, itemName: $itemName, placeDescription: $placeDescription, photoUrl: $photoUrl, itemColor: $itemColor, itemForm: $itemForm, itemGroup: $itemGroup, itemDescription: $itemDescription, placePhotoUrl: $placePhotoUrl}';
  }

  @override
  List<Object?> get props => [
        id,
        placeName,
        saveDateTime,
        fetchDateTime,
        itemName,
        placeDescription,
        photoUrl,
        itemColor,
        itemForm,
        itemGroup,
        itemDescription,
        placePhotoUrl,
      ];
}
