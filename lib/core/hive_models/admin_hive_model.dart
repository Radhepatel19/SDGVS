import 'package:hive/hive.dart';

@HiveType(typeId: 15) // Unique typeId
class AdminHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String role;

  @HiveField(4)
  String? villageId;

  @HiveField(5)
  late bool isFirstLogin;

  @HiveField(6)
  late String status;

  AdminHiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.villageId,
    required this.isFirstLogin,
    required this.status,
  });
}

class AdminHiveModelAdapter extends TypeAdapter<AdminHiveModel> {
  @override
  final int typeId = 15;

  @override
  AdminHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdminHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      role: fields[3] as String,
      villageId: fields[4] as String?,
      isFirstLogin: fields[5] as bool,
      status: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdminHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.villageId)
      ..writeByte(5)
      ..write(obj.isFirstLogin)
      ..writeByte(6)
      ..write(obj.status);
  }
}
