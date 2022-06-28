import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repositories.dart';

import '../models/todo.dart';
import '../widgets/todoListItem.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPosition;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value){
      setState((){
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma Tarefa.',
                        errorText: errorText,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:Colors.blueAccent,
                            width: 3
                          )
                        ),
                        labelStyle: TextStyle(
                          color: Colors.blueGrey
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      if(text.isEmpty){
                        setState((){
                          errorText = 'Título não pode ser vazio';
                        });
                        return;
                      }
                      setState(() {
                        Todo newTodo =
                            Todo(title: text, dateTime: DateTime.now());
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue, padding: EdgeInsets.all(14)),
                    child: Icon(Icons.add, size: 30),
                  )
                ],
              ),
              SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child:
                        Text('Você possui ${todos.length} tarefas pendentes'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: showDeletedTodosConfirmationDialog,
                    child: Text('Limpar tudo.'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue, padding: EdgeInsets.all(14)),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa [ ${todo.title} ] foi removida com sucesso...',
          style: TextStyle(color: Colors.red.shade900),
        ),
        backgroundColor: Colors.grey.shade200,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff060708),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPosition!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 7),
      ),
    );
  }

  void showDeletedTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('LIMPAR TUDO....?'),
        content: Text('Essa ação apagará todas as tarefas da sua lista.'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(primary: Colors.blue.shade900),
              child: Text('Cancelar')),
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(primary: Colors.red.shade900),
              child: Text('Confirmar') ),
        ],
      ),
    );
  }
  void deleteAllTodos(){
    setState((){
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
