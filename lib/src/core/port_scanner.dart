import 'dart:async';
import 'dart:io';
import '../models/network_address.dart';
import '../utils/utils.dart';

class PortScanner {
  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    required Duration timeout,
  }) {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }
    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = Utils.getPortFromPing(host, port, timeout);
      futures.add(f);
      f.then((socket) {
        socket.destroy();
        out.sink.add(NetworkAddress(host, openPorts: [port]));
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }
      });
    }
    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());
    return out.stream;
  }

  static Stream<NetworkAddress> discoverMultiplePorts(
    String subnet,
    List<int> ports, {
    required Duration timeout,
  }) {
    if (!Utils.isValidPort(ports)) {
      throw 'Provide a valid port range between 0 to 65535';
    }
    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final newNetworkAddress = NetworkAddress(host, openPorts: List.from([]));
      for (var port in ports) {
        final Future<Socket> f = Utils.getPortFromPing(host, port, timeout);
        futures.add(f);
        f.then((socket) async {
          socket.destroy();
          newNetworkAddress.openPorts.add(port);
          //add to stream at the last port
          if (port == ports.last) {
            out.sink.add(newNetworkAddress);
          }
        }).catchError((dynamic e) async {
          if (e is! SocketException) {
            throw e;
          }
          //in case the last port is not open but the host has other ports open
          if (port == ports.last && newNetworkAddress.openPorts.isNotEmpty) {
            out.sink.add(newNetworkAddress);
          }
        });
      }
    }
    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());
    return out.stream;
  }

  static Stream<NetworkAddress> discoverFromAddress(
    String address,
    int port, {
    required Duration timeout,
  }) {
    if (!Utils.isValidAddress(address)) {
      throw "Provide a valid IPADDRESS";
    }
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }
    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    final host = address;
    final Future<Socket> f = Utils.getPortFromPing(host, port, timeout);
    futures.add(f);
    f.then((socket) {
      socket.destroy();
      out.sink.add(NetworkAddress(host, openPorts: [port]));
    }).catchError((dynamic e) {
      if (e is! SocketException) {
        throw e;
      }
    });
    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }

  static Stream<NetworkAddress> discoverFromAddressMultiplePorts(
    String address,
    List<int> ports, {
    required Duration timeout,
  }) {
    if (!Utils.isValidAddress(address)) {
      throw "Provide a valid IPADDRESS";
    }
    if (!Utils.isValidPort(ports)) {
      throw 'Provide a valid port range between 0 to 65535';
    }

    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    final host = address;
    final newNetworkAddress = NetworkAddress(host, openPorts: List.from([]));

    for (var port in ports) {
      final Future<Socket> f = Utils.getPortFromPing(host, port, timeout);
      futures.add(f);
      f.then((socket) async {
        socket.destroy();
        newNetworkAddress.openPorts.add(port);
        //add to stream at the last port
        if (port == ports.last) {
          out.sink.add(newNetworkAddress);
        }
      }).catchError((dynamic e) async {
        if (e is! SocketException) {
          throw e;
        }
        //in case the last port is not open but the host has other ports open
        if (port == ports.last && newNetworkAddress.openPorts.isNotEmpty) {
          out.sink.add(newNetworkAddress);
        }
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }
}
