// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComplaintHiveModelAdapter extends TypeAdapter<ComplaintHiveModel> {
  @override
  final int typeId = 1;

  @override
  ComplaintHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComplaintHiveModel(
      id: fields[0] as String,
      category: fields[1] as String,
      description: fields[2] as String,
      imagePath: fields[3] as String?,
      voicePath: fields[4] as String?,
      timestamp: fields[5] as DateTime,
      status: fields[6] as String,
      adminRemarks: fields[7] as String?,
      pendingSync: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ComplaintHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.voicePath)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.adminRemarks)
      ..writeByte(8)
      ..write(obj.pendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplaintHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
