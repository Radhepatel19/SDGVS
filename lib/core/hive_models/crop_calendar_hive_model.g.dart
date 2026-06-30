// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_calendar_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropCalendarHiveModelAdapter extends TypeAdapter<CropCalendarHiveModel> {
  @override
  final int typeId = 10;

  @override
  CropCalendarHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropCalendarHiveModel(
      id: fields[0] as String,
      cropName: fields[1] as String,
      stage: fields[2] as String,
      recommendedDates: fields[3] as String,
      status: fields[4] as String,
      season: fields[5] as String,
      sowingPeriod: fields[6] as String,
      duration: fields[7] as String,
      harvestPeriod: fields[8] as String,
      bestSoil: fields[9] as String,
      waterRequirement: fields[10] as String,
      description: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CropCalendarHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cropName)
      ..writeByte(2)
      ..write(obj.stage)
      ..writeByte(3)
      ..write(obj.recommendedDates)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.season)
      ..writeByte(6)
      ..write(obj.sowingPeriod)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.harvestPeriod)
      ..writeByte(9)
      ..write(obj.bestSoil)
      ..writeByte(10)
      ..write(obj.waterRequirement)
      ..writeByte(11)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropCalendarHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
