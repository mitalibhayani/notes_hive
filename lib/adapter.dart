import 'package:hive/hive.dart';
part 'adapter.g.dart';

// part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject{
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late DateTime creationDate;


}