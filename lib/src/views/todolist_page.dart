import 'package:flutter/material.dart';
import 'package:lista_contatinhos/src/models/todo.dart';
import 'package:lista_contatinhos/src/repositories/todo_repository.dart';
import 'package:lista_contatinhos/src/widgets/todo_list_item.dart';

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
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Adicionar terefa',
                        hintText: 'Ex: Ir a padaria',
                        errorText: errorText,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      if (text.isEmpty) {
                        setState(() {
                          errorText = 'o campo não pode ficar vazio';
                        });
                        return;
                      }
                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[300],
                      fixedSize: const Size(
                        60,
                        60,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                    const SizedBox(
                      height: 26,
                    ),
                  ],
                ),
              ),
              //Spacer(),
              Row(
                children: [
                  const Expanded(
                      child: Text('Você possui 0 tarefas pendentes')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[300],
                      padding: const EdgeInsets.all(9),
                    ),
                    onPressed: showDeleteTodosFirmDialog,
                    child: const Text('Limpar tudo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa ${todo.title} foi removida com sucesso!'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosFirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja limpar tudo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
