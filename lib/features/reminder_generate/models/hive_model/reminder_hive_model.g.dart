// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderHiveModelAdapter extends TypeAdapter<ReminderHiveModel> {
  @override
  final int typeId = 0;

  @override
  ReminderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      time: fields[2] as String,
      scheduledTime: fields[3] as DateTime,
      type: fields[4] as String,
      afterDays: fields[5] as int?,
      customDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.scheduledTime)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.afterDays)
      ..writeByte(6)
      ..write(obj.customDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
