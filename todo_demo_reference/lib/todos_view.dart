import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'models/Todo.dart';

class TodosView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  // Track user input
  final _todoTitleController = TextEditingController();

  // Flag for tracking whether to filter Todos being displayed
  bool _showIncompleteOnly = false;

  // All Todos retrieved from DataStore
  List<Todo> _todos = [];

  // Todos to be displayed on screen
  List<Todo> get _presentedTodos {
    // Use flag to determine filter
    return _showIncompleteOnly
        ? _todos.where((todo) => !todo.isComplete).toList()
        : _todos;
  }

  // Trigger query to DataStore immediately
  @override
  void initState() {
    super.initState();
    _getTodos().then((value) {
      // Observe Todo events after initial query
      _observeTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _navigationBar(),
        body: Builder(builder: (context) {
          // Determine which view to show based on data
          if (_todos.isEmpty) {
            return _emptyTodosView();
          } else {
            return _todosListView();
          }
        }),
        floatingActionButton: _floatingActionButton());
  }

  // Builds view for a filter option
  PopupMenuItem _filterOption(String text, bool value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  // Filter button for the navigation bar
  Widget _filterButton() {
    return PopupMenuButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.filter_alt),
        ),
        itemBuilder: (context) {
          return [
            _filterOption('All', false),
            _filterOption('Incomplete Only', true)
          ];
        },
        onSelected: (showIncompleteOnly) {
          setState(() => _showIncompleteOnly = showIncompleteOnly);
        });
  }

  // Navigation bar
  AppBar _navigationBar() {
    return AppBar(
      title: Text('Todos'),
      actions: [_filterButton()],
    );
  }

  // Empty todos view
  Widget _emptyTodosView() {
    return Center(
      child: Text('No todos yet.'),
    );
  }

  // Todos list view
  Widget _todosListView() {
    return ListView.builder(
      itemCount: _presentedTodos.length,
      itemBuilder: (context, index) {
        final todo = _presentedTodos[index];
        return Card(
            // Checkbox view
            child: CheckboxListTile(
          title: Text(todo.body),
          value: todo.isComplete,

          // Trigger update functionality of Todo
          onChanged: (newValue) => _updateTodoCompletionStatus(todo, newValue),
        ));
      },
    );
  }

  // Create new Todo view
  Widget _createNewTodoView() {
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

                // Trigger todo to save
                _saveTodo();

                _todoTitleController.text = '';
              },
              child: Text('Save Todo'))
        ],
      ),
    );
  }

  // Floating action button
  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return _createNewTodoView();
            });
      },
    );
  }

  // Get Todos from DataStore
  Future<void> _getTodos() async {
    try {
      // Get all Todos
      final todos = await Amplify.DataStore.query(Todo.classType);

      // Update state
      setState(() => _todos = todos);
    } catch (e) {
      print(e);
    }
  }

  // Observe Todo events (create, update, delete)
  void _observeTodos() async {
    // Create a stream for Todo objects
    final stream = Amplify.DataStore.observe(Todo.classType);

    // Get Todos after new events
    stream.listen((event) => _getTodos());
  }

  // Update Todo isComplete value
  void _updateTodoCompletionStatus(Todo todo, bool isComplete) async {
    try {
      // Create copy with modified isComplete value
      final updatedTodo = todo.copyWith(isComplete: isComplete);

      // Update the Todo by saving it again (same ID)
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print(e);
    }
  }

  // Create new Todo
  void _saveTodo() async {
    try {
      // Create Todo with user input
      final newTodo = Todo(body: _todoTitleController.text, isComplete: false);

      // Save Todo to DataStore
      await Amplify.DataStore.save(newTodo);
    } catch (e) {
      print(e);
    }
  }
}
