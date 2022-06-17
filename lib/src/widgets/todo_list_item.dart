import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_contatinhos/src/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
        ),
        margin: EdgeInsets.only(bottom: 2.0),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(
                todo.dateTime,
              ),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              todo.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      endActionPane:
          ActionPane(motion: DrawerMotion(), extentRatio: 0.25, children: [
        SlidableAction(
          onPressed: (context) {
            onDelete(todo);
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
    );
  }
}
