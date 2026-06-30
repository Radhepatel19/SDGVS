// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoticeHiveModelAdapter extends TypeAdapter<NoticeHiveModel> {
  @override
  final int typeId = 2;

  @override
  NoticeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoticeHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      typeIndex: fields[3] as int,
      date: fields[4] as DateTime,
      isHighPriority: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NoticeHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.isHighPriority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
