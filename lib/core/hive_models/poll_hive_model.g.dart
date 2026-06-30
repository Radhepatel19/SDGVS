// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PollOptionHiveModelAdapter extends TypeAdapter<PollOptionHiveModel> {
  @override
  final int typeId = 4;

  @override
  PollOptionHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollOptionHiveModel(
      text: fields[0] as String,
      votes: fields[1] as int,
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PollOptionHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.votes)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollOptionHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollHiveModelAdapter extends TypeAdapter<PollHiveModel> {
  @override
  final int typeId = 5;

  @override
  PollHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollHiveModel(
      id: fields[0] as String,
      question: fields[1] as String,
      options: (fields[2] as List).cast<PollOptionHiveModel>(),
      totalVotes: fields[3] as int,
      expiryDate: fields[4] as DateTime,
      userVotedOptionIndex: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PollHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.totalVotes)
      ..writeByte(4)
      ..write(obj.expiryDate)
      ..writeByte(5)
      ..write(obj.userVotedOptionIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
