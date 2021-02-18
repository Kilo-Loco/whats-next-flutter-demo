import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_datastore/models/ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';

class TodosView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  final _todoTitleController = TextEditingController();
  List<Todo> _todos = [];
  bool _showIncompleteOnly = false;
  List<Todo> get _presentedTodos {
    return _showIncompleteOnly
        ? _todos.where((todo) => !todo.isComplete).toList()
        : _todos;
  }

  @override
  void initState() {
    super.initState();
    _getTodos();
    _observeTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.filter_alt),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('All'),
                    value: false,
                  ),
                  PopupMenuItem(
                    child: Text('Incomplete Only'),
                    value: true,
                  )
                ];
              },
              onSelected: (showIncompleteOnly) {
                setState(() => _showIncompleteOnly = showIncompleteOnly);
              })
        ],
      ),
      body: Builder(builder: (context) {
        if (_todos.isEmpty) {
          return Center(
            child: Text('No todos yet.'),
          );
        } else {
          return ListView.builder(
            itemCount: _presentedTodos.length,
            itemBuilder: (context, index) {
              final todo = _presentedTodos[index];
              return Card(
                  child: CheckboxListTile(
                title: Text(todo.body),
                value: todo.isComplete,
                onChanged: (newValue) =>
                    _updateTodoCompletionStatus(todo, newValue),
              ));
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Center(
                  child: Column(
                    children: [
                      TextField(
                        controller: _todoTitleController,
                        decoration: InputDecoration(labelText: 'Todo Title'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _saveTodo();
                          },
                          child: Text('Save Todo'))
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  void _getTodos() async {
    try {
      final todos = await Amplify.DataStore.query(Todo.classType);
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      print(e);
    }
  }

  void _observeTodos() async {
    final stream = Amplify.DataStore.observe(Todo.classType);
    stream.listen((event) {
      print('${event.eventType} occured');
      setState(() {
        switch (event.eventType) {
          case EventType.create:
            _todos.add(event.item);
            break;
          case EventType.update:
            final index = _todos.indexWhere((todo) => event.item.id == todo.id);
            _todos[index] = event.item;
            break;
          case EventType.delete:
            final index = _todos.indexWhere((todo) => event.item.id == todo.id);
            _todos.removeAt(index);
            break;
        }
      });
    });
  }

  void _updateTodoCompletionStatus(Todo todo, bool isComplete) async {
    try {
      final updatedTodo = todo.copyWith(isComplete: isComplete);
      await Amplify.DataStore.save(updatedTodo);
      print('${updatedTodo.body} completed: $isComplete');
      // _getTodos();
    } catch (e) {
      print(e);
    }
  }

  void _saveTodo() async {
    try {
      final newTodo = Todo(body: _todoTitleController.text, isComplete: false);
      await Amplify.DataStore.save(newTodo);
      print('saved ${newTodo.body}');
      _todoTitleController.text = '';
      // _getTodos();
    } catch (e) {
      print(e);
      Amplify.DataStore.clear();
    }
  }
}
