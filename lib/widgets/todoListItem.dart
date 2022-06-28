import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key,
    required this.todo,
    required this.onDelete
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        actionExtentRatio: 0.25,
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'deletar',
            onTap: (){
              onDelete(todo);
            },
          ),
          IconSlideAction(
            color: Colors.grey,
            icon: Icons.edit,
            caption: 'editar',
            onTap: (){},
          )
        ],
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyy - HH:mm').format(todo.dateTime),
                style: TextStyle(fontSize: 12),
              ),
              Text(todo.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
            ],
          ),
        ),
      ),
    );
  }
}
