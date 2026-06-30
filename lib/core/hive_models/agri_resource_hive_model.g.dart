// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agri_resource_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgriResourceHiveModelAdapter extends TypeAdapter<AgriResourceHiveModel> {
  @override
  final int typeId = 12;

  @override
  AgriResourceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgriResourceHiveModel(
      id: fields[0] as String,
      resourceName: fields[1] as String,
      availabilityPercent: fields[2] as String,
      statusColor: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AgriResourceHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.resourceName)
      ..writeByte(2)
      ..write(obj.availabilityPercent)
      ..writeByte(3)
      ..write(obj.statusColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgriResourceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
