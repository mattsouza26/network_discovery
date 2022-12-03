import './models/models.dart';
import 'core/host_scanner.dart';
import 'core/port_scanner.dart';

class NetworkDiscovery extends HostScanner with PortScanner {
  static Stream<HostActive> discoverAllPingableDevices(
    String subnet, {
    int firstHostId = 1,
    int lastHostId = 254,
    Duration timeout = const Duration(seconds: 1),
    bool resultsInAddressAscendingOrder = true,
  }) {
    return HostScanner.discoverAllPingableDevices(subnet,
        firstHostId: firstHostId,
        lastHostId: lastHostId,
        timeout: timeout,
        resultsInAddressAscendingOrder: resultsInAddressAscendingOrder);
  }

  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 3),
  }) {
    return PortScanner.discover(subnet, port, timeout: timeout);
  }

  static Stream<NetworkAddress> discoverMultiplePorts(
    String subnet,
    List<int> ports, {
    Duration timeout = const Duration(seconds: 3),
  }) {
    return PortScanner.discoverMultiplePorts(subnet, ports, timeout: timeout);
  }

  static Stream<NetworkAddress> discoverFromAddress(
    String address,
    int port, {
    Duration timeout = const Duration(seconds: 3),
  }) {
    return PortScanner.discoverFromAddress(address, port, timeout: timeout);
  }

  static Stream<NetworkAddress> discoverFromAddressMultiplePorts(
    String address,
    List<int> ports, {
    Duration timeout = const Duration(seconds: 3),
  }) {
    return PortScanner.discoverFromAddressMultiplePorts(address, ports,
        timeout: timeout);
  }

  static Future<String> discoverDeviceIpAddress() {
    return HostScanner.discoverDeviceIpAddress();
  }
}
