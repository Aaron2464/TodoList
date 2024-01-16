import 'package:todo_list/main.dart';

class TodoItem {
  TodoItem({
    required this.importance,
    required this.content,
    this.isCheck = false,
  });

  final Importance importance;
  final String content;
  bool isCheck;
}
