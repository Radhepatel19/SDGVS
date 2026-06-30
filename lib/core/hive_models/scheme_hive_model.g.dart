// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchemeHiveModelAdapter extends TypeAdapter<SchemeHiveModel> {
  @override
  final int typeId = 3;

  @override
  SchemeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchemeHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      description: fields[3] as String,
      objectives: (fields[4] as List).cast<String>(),
      eligibility: (fields[5] as List).cast<String>(),
      benefits: (fields[6] as List).cast<String>(),
      documentsRequired: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchemeHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.objectives)
      ..writeByte(5)
      ..write(obj.eligibility)
      ..writeByte(6)
      ..write(obj.benefits)
      ..writeByte(7)
      ..write(obj.documentsRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
