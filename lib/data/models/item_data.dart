import 'dart:convert';

import 'package:equatable/equatable.dart';


class ItemData extends Equatable {
  final String id;

  final String name;
  final String color;
  final String form;
  final String group;
  final String description;
  final String? photoUrl;

  ItemData({
    required this.id,
    required this.name,
    required this.color,
    required this.form,
    required this.group,
    required this.description,
    this.photoUrl,
  });

  ItemData copyWith({
    String? id,
    String? name,
    String? color,
    String? form,
    String? group,
    String? description,
    String? photoUrl,
   
  }) {
    return ItemData(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color, 
      form: form ?? this.form,
      group: group ?? this.group,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }


   Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'naidme': id,
      'name': name,
      'color': color,
      'form': form,
      'group': group, // enum to string
      'description': description,
      'photoUrl': photoUrl,
      
    };
  }

  factory ItemData.fromMap(Map<String, dynamic> map) {
    return ItemData(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as String,
      form: map['form'] as String,
      group: map['group'] as String,
      description: map['description'] as String,
      photoUrl: map['form'] as String,

    );
  }

  String toJson() => json.encode(toMap());

  factory ItemData.fromJson(String source) =>
      ItemData.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get stringify => true;


    @override
  String toString() {
    return 'ItemData{id: $id, name: $name, color: $color, form: $form, group: $group, description: $description, photoUrl: $photoUrl}';
  }

  @override
  List<Object?> get props => [id, name, color, form, group, description, photoUrl];

  
}


