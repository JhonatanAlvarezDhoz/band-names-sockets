import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_name/services/socket_services.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('ServiceStatus: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            socketService.socket.emit('flutter',
                {'nombre': "Flutter", 'message': "Hello since flutter"});
          }),
    );
  }
}
