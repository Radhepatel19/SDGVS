// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      id: fields[14] as String?,
      name: fields[0] as String?,
      village: fields[1] as String?,
      mobile: fields[2] as String,
      isRegistered: fields[4] as bool,
      isVerified: fields[5] as bool,
      profileImage: fields[6] as String?,
      email: fields[7] as String?,
      gender: fields[8] as String?,
      dob: fields[9] as DateTime?,
      address: fields[10] as String?,
      occupation: fields[11] as String?,
      district: fields[12] as String?,
      taluka: fields[13] as String?,
      villageId: fields[15] as String?,
      status: fields[16] as String,
      lastLogin: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(14)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.village)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(4)
      ..write(obj.isRegistered)
      ..writeByte(5)
      ..write(obj.isVerified)
      ..writeByte(6)
      ..write(obj.profileImage)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.dob)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.occupation)
      ..writeByte(12)
      ..write(obj.district)
      ..writeByte(13)
      ..write(obj.taluka)
      ..writeByte(15)
      ..write(obj.villageId)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.lastLogin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
