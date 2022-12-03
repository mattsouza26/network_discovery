import 'dart:async';
import 'dart:isolate';

import 'package:example/app/models/isolate_message_model.dart';
import 'package:example/app/models/network_model.dart';
import 'package:flutter/material.dart';
import 'package:network_discovery/network_discovery.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _ports = [22, 80, 443, 445, 3000, 13579];
  final List<NetworkModel> _listNetwork = [];
  bool isLooking = false;
  final receivePort = ReceivePort();
  Isolate? isolate;

  Future<void> _findDevices() async {
    try {
      //get device address
      final deviceIp = await NetworkDiscovery.discoverDeviceIpAddress();
      setState(() {
        _listNetwork.clear();
        isLooking = true;
      });
      //spawn isolate to find all devices on network
      isolate = await Isolate.spawn(
        discoveryDevices,
        IsolateMessageModel(receivePort.sendPort, args: [deviceIp, _ports]),
      );
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      //add listener to cominucate with isolate and receive all data
      receivePort.asBroadcastStream().listen((event) {
        if (event is List<NetworkModel>) {
          setState(() {
            _listNetwork.addAll(event);
            isLooking = false;
          });
        }
      });
    });

    //call function that look for devices
    _findDevices();
    super.initState();
  }

  @override
  void dispose() {
    receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Example network_discovery"),
      ),
      body: Column(children: [
        if (isLooking)
          const LinearProgressIndicator(minHeight: 5)
        else if (_listNetwork.isEmpty)
          const Expanded(
              child: Center(child: Text("Dispositivos nao encontrados!")))
        else
          Expanded(
            child: ListView.builder(
                itemCount: _listNetwork.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(_listNetwork[index].ip),
                    trailing:
                        Text(_listNetwork[index].ports.toList().toString()),
                  );
                })),
          ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isLooking) _findDevices();
        },
        child: const Icon(Icons.settings_input_antenna_rounded),
      ),
    );
  }
}

void discoveryDevices(IsolateMessageModel message) async {
  final address = message.args[0] as String;
  final ports = List<int>.from(message.args[1]);
  //list of devices
  final List<NetworkModel> newDevicesList = [];
  //get subnet from address
  final String subnet = address.substring(0, address.lastIndexOf('.'));
  //create stream for listener
  final stream = NetworkDiscovery.discoverMultiplePorts(subnet, ports);
  //await for the listener finish
  await stream.listen((data) {
    //create device from data
    final newDevices = NetworkModel(data.ip, data.openPorts);
    //add to list of devices
    newDevicesList.add(newDevices);
  }).asFuture();
  //kill isolate and send all devices found
  Isolate.exit(message.sendPort, newDevicesList);
}
