// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alert_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherAlertHiveModelAdapter extends TypeAdapter<WeatherAlertHiveModel> {
  @override
  final int typeId = 13;

  @override
  WeatherAlertHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherAlertHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      level: fields[3] as String,
      expiresAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherAlertHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherAlertHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
