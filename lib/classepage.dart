import 'package:flutter/material.dart';
import 'addclass.dart';
import 'widgets/bottombar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

main() {
  runApp(const ClassPage());
}

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var lw = MediaQuery.of(context).size.width;
    var lh = MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddClass()));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: lw / 10,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.teal,
        padding: EdgeInsets.all(lw / 15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(lw / 40, lh / 20, 0, lh / 40),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: lw / 10,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(lw / 10, lh / 15, 0, lh / 40),
                  // ignore: prefer_const_constructors
                  child: Text(
                    "My Classes",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, lh / 30),
              // ignore: prefer_const_constructors
              child: Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('Classes').get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Subject(
                              dataMap: snapshot.data!.docs[index].data()
                                  as Map<dynamic, dynamic>,
                              docId: snapshot.data!.docs[index].reference.id
                                  .toString(),
                            ),
                            Divide()
                          ],
                        );
                      },
                    );
                  } else {
                    // or your loading widget here
                    return Column(children: const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Loading...',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )
                    ]);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          SizedBox(height: lh / 10, child: const BottomNavBar()),
    ));
  }
}

// ignore: use_key_in_widget_constructors
class Divide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var lw = MediaQuery.of(context).size.width;
    var lh = MediaQuery.of(context).size.height;

    return (Container(
      padding: EdgeInsets.fromLTRB(lw / 40, lh / 60, lw / 40, lh / 50),
      child: const Divider(
        color: Colors.white,
        thickness: 2,
      ),
    ));
  }
}

class Subject extends StatelessWidget {
  Map dataMap;
  var docId;
  CollectionReference classes =
      FirebaseFirestore.instance.collection('Classes');

  Future<void> deleteClass() {
    return classes
        .doc(docId)
        .delete()
        .then((value) => print("Class Deleted"))
        .catchError((error) => print("Failed to delete Class: $error"));
  }

  Subject({Key? key, required this.dataMap, required this.docId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //var docId = dataMap[""]
    var subjectName = dataMap["subject"];
    var startTime = dataMap["fromTime"];
    var endTime = dataMap["toTime"];
    var day = dataMap["days"].toString().substring(0, 3);
    var lw = MediaQuery.of(context).size.width;
    var lh = MediaQuery.of(context).size.height;
    print(docId);
    print(dataMap);

    return (Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 0.0, right: lw / 40),
        padding: EdgeInsets.fromLTRB(lw / 40, lh / 100, lw / 40, lh / 100),
        width: lw / 2,
        decoration: BoxDecoration(
            // border: Border(left: BorderSide(color: Colors.black, width:3)),
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$subjectName",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: lh / 40,
                  ),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$startTime - $endTime",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: lh / 40,
                    ),
                  ),
                ))
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(lw / 40),
        decoration: BoxDecoration(
            color: Colors.amber[50], borderRadius: BorderRadius.circular(5)),

        child: SizedBox(
          width: lw / 10,
          height: lh / 20,
          child: Text(
            "$day",
            style: TextStyle(
                color: Colors.black.withOpacity(0.5), fontSize: lh / 40),
          ),
        ),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      ),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5)),
          margin: const EdgeInsets.only(left: 10.0, right: 0.0),
          padding: EdgeInsets.fromLTRB(lw / 80, lh / 200, lw / 80, lh / 200),
          child: IconButton(
              iconSize: lh / 35,
              onPressed: () {
                deleteClass();
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ))),
    ]));
  }
}
