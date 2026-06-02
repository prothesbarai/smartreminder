// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleHiveModelAdapter extends TypeAdapter<ScheduleHiveModel> {
  @override
  final int typeId = 1;

  @override
  ScheduleHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      dateTime: fields[2] as DateTime,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
