// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mandi_price_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MandiPriceHiveModelAdapter extends TypeAdapter<MandiPriceHiveModel> {
  @override
  final int typeId = 11;

  @override
  MandiPriceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MandiPriceHiveModel(
      id: fields[0] as String,
      cropName: fields[1] as String,
      price: fields[2] as String,
      change: fields[3] as String,
      mandi: fields[4] as String,
      minPrice: fields[5] as String,
      maxPrice: fields[6] as String,
      unit: fields[7] as String,
      status: fields[8] as String,
      date: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MandiPriceHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cropName)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.change)
      ..writeByte(4)
      ..write(obj.mandi)
      ..writeByte(5)
      ..write(obj.minPrice)
      ..writeByte(6)
      ..write(obj.maxPrice)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MandiPriceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
