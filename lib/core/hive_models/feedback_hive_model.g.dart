// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackHiveModelAdapter extends TypeAdapter<FeedbackHiveModel> {
  @override
  final int typeId = 8;

  @override
  FeedbackHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackHiveModel(
      id: fields[0] as String,
      complaintId: fields[1] as String,
      rating: fields[2] as int,
      comments: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.complaintId)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.comments)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
