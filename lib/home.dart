import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: "Metalica", votes: 1),
    Band(id: '2', name: "Linkin Park", votes: 5),
    Band(id: '3', name: "Evanence", votes: 2),
    Band(id: '4', name: "Braking benjamin", votes: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("BandNames", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          return _bandTile(bands[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: _addNewBand,
          child: const Icon(Icons.plus_one_rounded)),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print(direction);
      },
      background: Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            "Delete Band",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => print(band.name),
      ),
    );
  }

  _addNewBand() {
    final textname = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("New BandName"),
              content: TextField(
                controller: textname,
              ),
              actions: <Widget>[
                MaterialButton(
                    textColor: Colors.blue,
                    elevation: 5,
                    onPressed: () => addBandToList,
                    child: const Text("add"))
              ],
            );
          });
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text("New BandName"),
          content: CupertinoTextField(
            controller: textname,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Add"),
              onPressed: () => addBandToList(textname.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Dismiss"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    print(name);

    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
