import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: "Metalica", votes: 1),
    // Band(id: '2', name: "Linkin Park", votes: 5),
    // Band(id: '3', name: "Evanence", votes: 2),
    // Band(id: '4', name: "Braking benjamin", votes: 4),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("BandNames", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraphic(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
                return _bandTile(bands[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1,
          onPressed: _addNewBand,
          child: const Icon(Icons.plus_one_rounded)),
    );
  }

  Widget _bandTile(Band band) {
    final socketServices = Provider.of<SocketServices>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        socketServices.socket.emit('delete', {"id": band.id});
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
        onTap: () {
          socketServices.socket.emit('votes', {'id': band.id});
        },
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
    if (name.length > 1) {
      final socketServices =
          Provider.of<SocketServices>(context, listen: false);

      socketServices.socket.emit("add", {"name": name});
    }

    Navigator.pop(context);
  }

  Widget _showGraphic() {
    Map<String, double> dataMap = {};

    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    return PieChart(
      dataMap: dataMap,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
