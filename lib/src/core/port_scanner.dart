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
      throw 'Provide a valid port range between 0 to 65535';
    }
    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> socket = Utils.getPortFromPing(host, port, timeout);
      futures.add(socket);

      socket.then((Socket s) {
        s.destroy();
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
      final networkAddress = NetworkAddress(host, openPorts: List.from([]));
      for (var port in ports) {
        final Future<Socket> socket =
            Utils.getPortFromPing(host, port, timeout);
        futures.add(socket);

        socket.then((Socket s) async {
          s.destroy();
          networkAddress.openPorts.add(port);
        }).catchError((dynamic e) async {
          if (e is! SocketException) {
            throw e;
          }
        });
      }

      Future.wait<Socket>(futures).then<void>((sockets) {
        out.sink.add(networkAddress);
      }).catchError((dynamic e) {
        if (networkAddress.openPorts.isNotEmpty) {
          out.sink.add(networkAddress);
        }
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }

  static Future<NetworkAddress> discoverFromAddress(
    String address,
    int port, {
    required Duration timeout,
  }) async {
    if (!Utils.isValidAddress(address)) {
      throw "Provide a valid ip address";
    }
    if (port < 1 || port > 65535) {
      throw 'Provide a valid port range between 0 to 65535';
    }

    final Future<Socket> socket =
        Utils.getPortFromPing(address, port, const Duration(seconds: 2));
    final networkAddress = NetworkAddress(address, openPorts: List.from([]));

    await socket.then((Socket s) {
      s.destroy();
      networkAddress.openPorts.add(port);
    }).catchError((dynamic e) {
      if (e is! SocketException) {
        throw e;
      }
    });
    return networkAddress;
  }

  static Future<NetworkAddress> discoverFromAddressMultiplePorts(
    String address,
    List<int> ports, {
    required Duration timeout,
  }) async {
    if (!Utils.isValidAddress(address)) {
      throw "Provide a valid ip address";
    }
    if (!Utils.isValidPort(ports)) {
      throw 'Provide a valid port range between 0 to 65535';
    }

    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    final host = address;
    final networkAddress = NetworkAddress(host, openPorts: List.from([]));

    for (var port in ports) {
      final Future<Socket> socket = Utils.getPortFromPing(host, port, timeout);
      futures.add(socket);
      socket.then((Socket s) async {
        s.destroy();
        networkAddress.openPorts.add(port);
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }
      });
    }

    Future.wait<Socket>(futures).then<void>((sockets) {
      out.sink.add(networkAddress);
      out.close();
    }).catchError((dynamic e) {
      out.sink.add(networkAddress);
      out.close();
    });

    return out.stream.first;
  }
}
