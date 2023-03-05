part of 'objects.dart';

@JsonSerializable()
class Todo{
  String id;
  String todoName;
  bool completedStatus;

  Todo({required this.id, required this.todoName, this.completedStatus = false});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}