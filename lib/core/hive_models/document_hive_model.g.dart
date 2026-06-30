// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentHiveModelAdapter extends TypeAdapter<DocumentHiveModel> {
  @override
  final int typeId = 6;

  @override
  DocumentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      uploadDate: fields[3] as DateTime,
      filePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.uploadDate)
      ..writeByte(4)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
