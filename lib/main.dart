import 'package:flutter/material.dart';
import 'package:todo_list/todo_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Importance { none, low, medium, high }

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Importance importance = Importance.none;
  final TextEditingController _controller = TextEditingController();
  List<TodoItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              key: Key(item.content),
              direction: DismissDirection.endToStart,
              background: Container(),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: const Alignment(0.9, 0),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              child: ListTile(
                title: Text(
                  '${item.importance.name.toUpperCase()}  ${item.content}',
                  style: TextStyle(
                    fontSize: 18.0,
                    decoration:
                        item.isCheck ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                    value: item.isCheck,
                    onChanged: (bool? isCheck) {
                      setState(() {
                        item.isCheck = isCheck ?? false;
                      });
                    }),
                trailing: Text(
                  howManyMark(item.importance),
                  style: const TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBottomSheet,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, myState) {
            return Container(
              height: 250.0 + MediaQuery.of(context).viewInsets.bottom,
              padding: EdgeInsets.only(
                left: 24.0,
                top: 8.0,
                right: 24.0,
                bottom: 8.0 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          importance = Importance.none;
                          _controller.clear();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      IconButton(
                        onPressed: _controller.text.isNotEmpty &&
                                _controller.text != ''
                            ? () {
                                setState(() {
                                  items.add(
                                    TodoItem(
                                      importance: importance,
                                      content: _controller.text,
                                    ),
                                  );
                                  _controller.clear();
                                  Navigator.pop(context);
                                });
                              }
                            : null,
                        icon: const Icon(Icons.save),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _controller,
                    onChanged: (text) => myState(() {}),
                    onFieldSubmitted: (text) => myState(() {}),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 6.0),
                      isDense: true,
                      labelText: 'Content',
                    ),
                  ),
                  const Text(
                    'Importance',
                  ),
                  Center(
                    child: SegmentedButton<Importance>(
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<Importance>>[
                        ButtonSegment<Importance>(
                          value: Importance.none,
                          label: Text('None'),
                        ),
                        ButtonSegment<Importance>(
                          value: Importance.low,
                          label: Text('Low'),
                        ),
                        ButtonSegment<Importance>(
                          value: Importance.medium,
                          label: Text('Medium'),
                        ),
                        ButtonSegment<Importance>(
                          value: Importance.high,
                          label: Text('High'),
                        ),
                      ],
                      selected: <Importance>{importance},
                      onSelectionChanged: (Set<Importance> newImportance) {
                        myState(() {
                          importance = newImportance.first;
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}

String howManyMark(Importance importance) {
  switch (importance) {
    case Importance.none:
      return '';
    case Importance.low:
      return '!';
    case Importance.medium:
      return '!!';
    case Importance.high:
      return '!!!';
    default:
      return '';
  }
}
