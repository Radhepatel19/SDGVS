// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agri_notice_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgriNoticeHiveModelAdapter extends TypeAdapter<AgriNoticeHiveModel> {
  @override
  final int typeId = 14;

  @override
  AgriNoticeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgriNoticeHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AgriNoticeHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgriNoticeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
