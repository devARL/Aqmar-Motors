import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as p;


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
  var str = "ali";
  var items = new List<String>();
  var indx = 0;
  var edt = false;
  var txtDList = new List<TextDecoration>();
  var txtDDone = new List<String>();
  var itemIndex = 0;
  SharedPreferences prefs;
  final myController = TextEditingController();
  var ran = new Random();
  Database db;
  String dbPath;
  int index1;
  int index2;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createDb();
    //loadListView();
  }

  Future createDb() async {
    Directory path = await getApplicationDocumentsDirectory();
    dbPath = p.join(path.path, "database2.db");
    print('db apth= $dbPath');
    db = await openDatabase(dbPath, version: 1, onCreate: this.createTable);
    getData();
  }

  Future createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS todoItem (id INTEGER PRIMARY KEY, item TEXT NOT NULL, done BOOL NOT NULL)""");
    await db.close();
  }

  Future getData() async {
    print('get dbpath= $dbPath');
    db = await openDatabase(dbPath);
    var count = await db.rawQuery("SELECT COUNT(*) FROM todoItem");

    if (count != 1) {
        try {
          db = await openDatabase(dbPath);
          List<Map> lst = await db.rawQuery('SELECT item,done,id FROM todoItem');
          await db.close();
          print(lst);
          items.clear();
          txtDDone.clear();
          txtDList.clear();
          for (int i = 0; i< lst.length; i++) {
            items.add(lst[i]["item"]);
            txtDDone.add(lst[i]["done"]);
          }

          print(items);
          print(txtDDone);

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

        } catch(e) {
          print(e);
        }
    }
      else {
        print("length is not greater than 1");
      }
  }

   _handleAccept(int data, int index) async {
     print("data : $data");
     print("index: $index");
     this.index1= data;
     this.index2 = index;

     String imageToMove = items[data];
     items.removeAt(data);
     items.insert(index, imageToMove);

     String txtDoneToMove = txtDDone[data];
     txtDDone.removeAt(data);
     txtDDone.insert(index, txtDoneToMove);

     TextDecoration txtDecorationToMove = txtDList[data];
     txtDList.removeAt(data);
     txtDList.insert(index, txtDecorationToMove);

     try {
       print('db path = $dbPath');
       db = await openDatabase(dbPath);
       List<Map> lst = await db.rawQuery('SELECT item,done FROM todoItem WHERE id = ?',[(this.index2 + 1)]);
       await db.close();
       String lstItem1;
       String d1;
       String lstItem2;
       String d2;

       lstItem1 = lst[0]["item"];
       d1 = lst[0]["done"];

       db = await openDatabase(dbPath);
       lst = await db.rawQuery('SELECT item,done FROM todoItem WHERE id = ?',[(this.index1 + 1)]);
       await db.close();
       lstItem2 = lst[0]["item"];
       d2 = lst[0]["done"];

       print("updating valuein db");
       db = await openDatabase(dbPath);
       if (d2 == "true") {
         await db.rawUpdate("UPDATE todoItem SET item = ?, done = ? WHERE id = ?",[lstItem2,'true',(this.index2 + 1)]);
        }
       else {
         await db.rawUpdate("UPDATE todoItem SET item = ?, done = ? WHERE id = ?",[lstItem2,'false',(this.index2 + 1)]);
        }

       db = await openDatabase(dbPath);
       if (d1 == "true") {
         await db.rawUpdate("UPDATE todoItem SET item = ?, done = ? WHERE id = ?",[lstItem1,'true',(this.index1 + 1)]);
       }
       else {
         await db.rawUpdate("UPDATE todoItem SET item = ?, done = ? WHERE id = ?",[lstItem1,'false',(this.index1 + 1)]);
       }
       print("done");
     } catch(e) {
       print(e);
     }
     /*setState(() {

     }); */
    /*try {
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList("items", items);
      prefs.setStringList("done", txtDDone);
      loadListView();
    } catch (e) {
      print("error in dragging value: $e");
    }*/
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

   deleteValue() async {
     items.removeAt(indx);
     txtDDone.removeAt(indx);
     txtDList.removeAt(indx);
     try{
       print("deleting valuein db");
       db = await openDatabase(dbPath);
       await db.rawDelete("DELETE FROM todoItem WHERE id = ?",[(indx + 1)]);
       //await db.close();
       print("done");
     } catch(e) {
       print("error in updating value in db: $e");
     }
     setState(() {

     });
    /*try {
       prefs = await SharedPreferences.getInstance();
       prefs.setStringList("items", items);
       prefs.setStringList("done", txtDDone);
       loadListView();
     } catch (e) {
       print("error in delete value: $e");
     }*/
  }

  makeStrikeThoroughText() async {
    print(txtDDone[indx]);
     if (txtDDone[indx] == "true") {
       print("1");
       txtDDone[indx] = "false";
       print(txtDDone[indx]);
       txtDList[indx] = TextDecoration.none;
       print("2");
       try{
         print("updating valuein db");
         db = await openDatabase(dbPath);
         await db.rawUpdate('UPDATE todoItem SET done = ?, WHERE id = ?',['false',(indx + 1)]);
         print("done");
       } catch(e) {
         print("error in updating value in db: $e");
       }
     }
     else {
       txtDDone[indx] = "true";
       txtDList[indx] = TextDecoration.lineThrough;
       try{
         print("updating valuein db");
         db = await openDatabase(dbPath);
         await db.rawUpdate('UPDATE todoItem SET done = ? WHERE id = ?',["true",(indx + 1)]);
         print("done");
       } catch(e) {
         print("error in updating value in db: $e");
       }
   }
    setState(() {

    });
    /*try {
       prefs = await SharedPreferences.getInstance();
       prefs.setStringList("items", items);
       prefs.setStringList("done", txtDDone);
       //prefs.commit();
       loadListView();
     } catch (e) {
       print("error in change List View: $e");
     } */
  }

  changeListView()  async {
    if (edt) {
      print("1");
        items[indx] = myController.text;
        print('index of item $indx');
        print('item ${items[indx]}');
        try{
          print('myController.tetx= ${myController.text}');
          print("updating valuein db");
          //db = await openDatabase(dbPath);
          //await db.rawUpdate('UPDATE todoItem SET item = ? WHERE id = ${(indx + 1)}',[myController.text]);

          db = await openDatabase(dbPath);
          await db.rawDelete("DELETE FROM todoItem WHERE id = ?",[(indx + 1)]);

          if (txtDDone[indx] == "true") {
            await db.rawInsert("INSERT INTO todoItem (item, done) VALUES ('${myController.text}', 'true')");
            }
          else {
            await db.rawInsert("INSERT INTO todoItem (item, done) VALUES ('${myController.text}', 'false')");
            }




          // int count = await dbClient.rawUpdate(
           //   'UPDATE Empresa SET Nome = ?, ipServidorGestao = ?, portaServidorGestao = ?, ipServidorVendas = ?, portaServidorVendas = ?,'
           //       ' CNPJ = ?, SenhaREST = ? WHERE EmpresaId = $EmpresaId',
            //  [Nome, ipServidorGestao, portaServidorGestao, ipServidorVendas, portaServidorVendas, CNPJ, SenhaREST]);


          //await db.rawDelete("DELETE FROM todoItem WHERE id = ?",[(indx + 1)]);

          //'UPDATE Empresa SET Nome = ?, ipServidorGestao = ?, portaServidorGestao = ?, ipServidorVendas = ?, portaServidorVendas = ?,'
             // ' CNPJ = ?, SenhaREST = ? WHERE EmpresaId = $EmpresaId',

    //rawUpdate(
   // 'UPDATE Empresa SET Selecionado = 1 WHERE EmpresaId = ?',
   // [EmpresaId]);

    //await db.close();
          print("done");
        } catch(e) {
          print("error in updating value in db: $e");
        }
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
      try{
        print("inserting valuein db");
        db = await openDatabase(dbPath);
        await db.rawInsert("INSERT INTO todoItem (item, done) VALUES ('${myController.text}', 'false')");
        print("done");
      } catch(e) {
        print("error in inserting value in db: $e");
      }
  }
      setState(() {

      });
  /* try {
      prefs = await SharedPreferences.getInstance();
      prefs.setStringList("items", items);
      prefs.setStringList("done", txtDDone);
      //prefs.commit();
      loadListView();
    } catch (e) {
       print("error in inserting value in SharedPreferences: $e");
    }*/
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: new IconButton(icon: const Icon(Icons.home), onPressed: () {

          },
            color: Colors.white,),
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
