// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAccountHiveModelAdapter extends TypeAdapter<UserAccountHiveModel> {
  @override
  final int typeId = 2;

  @override
  UserAccountHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAccountHiveModel(
      userId: fields[0] as String,
      balance: fields[1] as double,
      plan: fields[2] as String,
      paidStartDate: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAccountHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.plan)
      ..writeByte(3)
      ..write(obj.paidStartDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccountHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
