import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_discovery/src/network_discovery.dart';
import 'package:network_discovery/src/utils/utils.dart';

void main() async {
  group('Testing Host Scanner', () {
    test('Running check deviceIP is valid ip address test', () async {
      final ip = await NetworkDiscovery.discoverDeviceIpAddress();
      expect(true, Utils.isValidAddress(ip));
    });

    test('Running discover available host on network in a given subnet test',
        () async {
      final stream = NetworkDiscovery.discoverAllPingableDevices("192.168.1");
      await stream.listen((host) {
        //show only is pingable
        if (host.isActive) {
          debugPrint(host.ip);
        }
      }).asFuture();
    });
  });

  group('Testing Port Scanner', () {
    test(
        'Running discover available network devices in a given subnet on a given port test',
        () async {
      final stream = NetworkDiscovery.discover("192.168.1", 80);
      await stream.listen((addr) {
        debugPrint(addr.ip);
      }).asFuture();
    });

    test(
        'Running discover available network devices on a given subnet on various given ports test',
        () async {
      final stream = NetworkDiscovery.discoverMultiplePorts(
          "192.168.1", [80, 443, 3000, 448, 13579]);
      await stream.listen((host) {
        debugPrint(host.toString());
      }).asFuture();
    });

    test(
        'Running check an available port at a given address on a given port test',
        () async {
      final device =
          await NetworkDiscovery.discoverFromAddress("192.168.1.1", 80);
      debugPrint(device.toString());
    });

    test(
        'Running check available ports at a given address on various given ports test',
        () async {
      final device = await NetworkDiscovery.discoverFromAddressMultiplePorts(
          "192.168.1.1", [3000, 80, 443, 13579, 58526]);
      debugPrint(device.toString());
    });
  });
}
