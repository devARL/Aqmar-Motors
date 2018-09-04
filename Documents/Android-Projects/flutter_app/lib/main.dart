import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //var wp = new WordPair.random();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      color:  Colors.green,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new myPage(),
    );
  }
}

class myPage extends StatefulWidget {

  @override
  myPageState createState() => new myPageState();
}

class myPageState extends State<myPage> {
  //String wp = "Hello world";
  //final wps = <WordPair>[];
  //final items = List<String>.generate(100, (a) => "Item $a");
  //final formKey = GlobalKey<FormState>();

  var str = "ali";
  var items = new List<String>();
  var indx = 0;
  var edt = false;
  var txtd =  TextDecoration.none;
  var txtDList = new List<TextDecoration>();
  var txtDDone = new List<String>();
  var itemIndex = 0;
  SharedPreferences prefs;
  final myController = TextEditingController();
  var ran = new Random();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
   loadListView();
  }

   _handleAccept(int data, int index) async {
     String imageToMove = items[data];
     items.removeAt(data);
     items.insert(index, imageToMove);
    try {
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList("items", items);
      prefs.setStringList("done", txtDDone);
      loadListView();
    } catch (e) {
      print("error in dragging value: $e");
    }
  }

  loadListView() async {
    try {
      prefs = await SharedPreferences.getInstance();
     //prefs.clear();
      items = prefs.getStringList("items");
      txtDDone = prefs.getStringList("done");
      if (txtDDone != null && items != null) {
        txtDList.clear();
        for (int i = 0; i < txtDDone.length; i++) {
          if (txtDDone[i] == "true") {
            txtDList.insert(i, TextDecoration.lineThrough);
          }
          else {
            txtDList.insert(i, TextDecoration.none);
          }
        }
        setState(() {

        });
      }
      else {
      }
    } catch(e) {
      print("error in Load List view: $e");
    }
  }

  /*void changeText() {
    setState(() {
      //final wp2 = new WordPair.random();
      //wp = wp2.asPascalCase;
    });
  }*/

   deleteValue() async {
     items.removeAt(indx);
     txtDDone.removeAt(indx);
     txtDList.removeAt(indx);
    try {
       prefs = await SharedPreferences.getInstance();
       prefs.setStringList("items", items);
       prefs.setStringList("done", txtDDone);
       loadListView();
     } catch (e) {
       print("error in delete value: $e");
     }
  }

  makeStrikeThoroughText() async {
     if (txtDDone[indx] == "true") {
       txtDDone[indx] = "false";
       txtDList[indx] = TextDecoration.none;
     }
     else {
       txtDDone[indx] = "true";
       txtDList[indx] = TextDecoration.lineThrough;
   }
   try {
       prefs = await SharedPreferences.getInstance();
       prefs.setStringList("items", items);
       prefs.setStringList("done", txtDDone);
       //prefs.commit();
       loadListView();
     } catch (e) {
       print("error in change List View: $e");
     }
  }

  changeListView()  async {
    if (edt) {
        items[indx] = myController.text;
      }
      else {
      if (items == null) {
        items = new List<String>();
        txtDDone = new List<String>();
      }
        try{
          items.add(myController.text);
          txtDDone.add("false");
          txtDList.add(TextDecoration.none);
        } catch(e) {
          print("error in adding: $e");
        }
      }
      print(items);
     try {
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList("items", items);
      prefs.setStringList("done", txtDDone);
      //prefs.commit();
      loadListView();
    } catch (e) {
       print("error in change List View: $e");
    }
  }

    _showDialog() async {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
              return new AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                          controller: myController,
                            autofocus: true,
                          decoration: new InputDecoration(
                            labelText: 'Add item:',
                          ),
                        ),
                    )
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () async {
                      await changeListView();
                      myController.text = "";
                      Navigator.pop(context);
                    },
                      child: const Text('Save'),
                  ),
                  new FlatButton(
                      onPressed: () {
                        if (edt) {
                          edt = false;
                        }
                        myController.text = "";
                        Navigator.pop(context);},
                      child: const Text('cancel'),
                  ),
                ],
              );
          }
      );
    }

  Widget makeListView() {
    return new LayoutBuilder(builder: (context, constraint) {
      return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return new LongPressDraggable(
            key: new ObjectKey(index),
            data: index,
            child: new DragTarget<int>(
              onAccept: (int data) async {
               await _handleAccept(data, index);
              },
              builder: (BuildContext context, List<int> data, List<dynamic> rejects) {
                return new Card(
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: new IconButton(icon: const Icon(Icons.strikethrough_s), color: Colors.blue, onPressed: () async {
                            indx = index;
                            await makeStrikeThoroughText();
                          }),
                          trailing: new IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () async {
                            indx = index;
                            await deleteValue();
                          }),

                          title:
                          Text('${items[index]}', style: TextStyle(decoration: txtDList[index]),),
                          onTap: () {
                            edt = true;
                            indx = index;
                            myController.text = items[index];
                            _showDialog();
                          },
                        ),
                      ],
                    )
                );
              },
              onLeave: (int data) {
                // Debug
                print('$data is Leaving row $index');
              },
              onWillAccept: (int data) {
                // Debug
                print('$index will accept row $data');

                return true;
              },
            ),
            onDragStarted: () {
              Scaffold.of(context).showSnackBar(new SnackBar (
                content: new Text("Drag the row onto another row to change places"),
              ));

            },
            onDragCompleted: () {
              print("Finished");
            },
            feedback: new SizedBox(
                width: constraint.maxWidth,
                child: new Card (
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new IconButton(icon: const Icon(Icons.strikethrough_s), color: Colors.blue, onPressed: () async {
                          indx = index;
                          await makeStrikeThoroughText();
                        }),
                        trailing: new IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () async {
                          indx = index;
                          await deleteValue();
                        }),

                        title:
                        Text('${items[index]}', style: TextStyle(decoration: txtDList[index]),),
                        onTap: () {
                          edt = true;
                          indx = index;
                          myController.text = items[index];
                          _showDialog();
                        },

                      ),
                    ],
                  ),
                  elevation: 18.0,
                )
            ),
            childWhenDragging: new Container(),
          );
        },
      );
    });

     /*return ListView.builder(
      itemCount: (items.length * 2),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context,i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return ListTile(
            leading: new IconButton(icon: const Icon(Icons.strikethrough_s), color: Colors.blue, onPressed: () async {
              indx = index;
              await makeStrikeThoroughText();
            }),
            trailing: new IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () async {
              indx = index;
              await deleteValue();
            }),

            title:
            Text('${items[index]}', style: TextStyle(decoration: txtDList[index]),),
            onTap: () {
              edt = true;
              indx = index;
              myController.text = items[index];
              _showDialog();
            },
          );
        },
    );*/


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('ToDo List'),
          backgroundColor: Colors.green,
          centerTitle: true,
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.add),
                onPressed: () {
              edt = false;
              _showDialog();
              },
            ),
          ],
        ),
        body: makeListView(),
    );
  }
}

/*import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {

  List<String> rows = new List<String>()
    ..add('Row 1')
    ..add('Row 2')
    ..add('Row 3')
    ..add('Row 4');


  @override
  Widget build(BuildContext context) {
    final title = 'Sortable ListView';
    return new MaterialApp(title: title, home: new Scaffold(appBar: new AppBar(title: new Text(title),),
      body:
        new LayoutBuilder(builder: (context, constraint) {
          return new ListView.builder(
            itemCount: rows.length,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              return new LongPressDraggable(
                key: new ObjectKey(index),
                data: index,
                child: new DragTarget<int>(
                  onAccept: (int data) {
                    _handleAccept(data, index);
                  },
                  builder: (BuildContext context, List<int> data, List<dynamic> rejects) {
                    return new Card(
                        child: new Column(
                          children: <Widget>[
                            new ListTile(
                                leading: new Icon(Icons.photo),
                                title: new Text(rows[index])
                            ),
                          ],
                        )
                    );
                  },
                  onLeave: (int data) {
                    // Debug
                    print('$data is Leaving row $index');
                  },
                  onWillAccept: (int data) {
                    // Debug
                    print('$index will accept row $data');

                    return true;
                  },
                ),
                onDragStarted: () {
                  Scaffold.of(context).showSnackBar(new SnackBar (
                    content: new Text("Drag the row onto another row to change places"),
                  ));

                },
                onDragCompleted: () {
                  print("Finished");
                },
                feedback: new SizedBox(
                    width: constraint.maxWidth,
                    child: new Card (
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text(rows[index]),
                            trailing: new Icon(Icons.reorder),
                          ),
                        ],
                      ),
                      elevation: 18.0,
                    )
                ),
                childWhenDragging: new Container(),
              );
            },
          );
        }),
      ),
    );
  }
} */