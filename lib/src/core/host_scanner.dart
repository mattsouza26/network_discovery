import 'dart:async';
import 'dart:math';
import 'package:network_discovery/src/models/host_active.dart';
import 'package:network_discovery/src/utils/utils.dart';
import 'dart:io';

class HostScanner {
  static Stream<HostActive> discoverAllPingableDevices(
    String subnet, {
    required int firstHostId,
    required int lastHostId,
    required Duration timeout,
    required bool resultsInAddressAscendingOrder,
  }) async* {
    final int maxEnd = Utils.getMaxHost(subnet);
    if (firstHostId > lastHostId ||
        firstHostId < 1 ||
        lastHostId < 1 ||
        firstHostId > maxEnd ||
        lastHostId > maxEnd) {
      throw 'Invalid subnet range or firstHostId < lastHostId is not true';
    }
    final int lastValidSubnet = min(lastHostId, maxEnd);
    final out = StreamController<HostActive>();
    final futures = <Future<HostActive>>[];

    for (int i = firstHostId; i <= lastValidSubnet; i++) {
      final host = '$subnet.$i';
      final Future<HostActive> f = Utils.getHostFromPing(host, timeout);
      futures.add(f);
      f.then((host) {
        out.sink.add(host);
      }).catchError((e) {
        throw e;
      });
    }

    Future.wait<HostActive>(futures)
        .then<void>((host) => out.close())
        .catchError((dynamic e) => out.close());

    if (!resultsInAddressAscendingOrder) {
      yield* out.stream;
    }

    for (final Future<HostActive> host in futures) {
      final HostActive tempHost = await host;
      yield tempHost;
    }
  }

  static Future<String> discoverDeviceIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);
    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          throw "Couldn't get IP Address";
        }
      }
    }
  }
}
