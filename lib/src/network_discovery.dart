import './models/models.dart';
import 'core/host_scanner.dart';
import 'core/port_scanner.dart';

class NetworkDiscovery {
  static final NetworkDiscovery _instance = NetworkDiscovery._();

  factory NetworkDiscovery() {
    return _instance;
  }

  NetworkDiscovery._();

  static Future<String> discoverDeviceIpAddress() {
    return HostScanner.discoverDeviceIpAddress();
  }

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
    Duration timeout = const Duration(seconds: 2),
  }) {
    return PortScanner.discover(subnet, port, timeout: timeout);
  }

  static Stream<NetworkAddress> discoverMultiplePorts(
    String subnet,
    List<int> ports, {
    Duration timeout = const Duration(seconds: 2),
  }) {
    return PortScanner.discoverMultiplePorts(subnet, ports, timeout: timeout);
  }

  static Future<NetworkAddress> discoverFromAddress(
    String address,
    int port, {
    Duration timeout = const Duration(seconds: 2),
  }) {
    return PortScanner.discoverFromAddress(address, port, timeout: timeout);
  }

  static Future<NetworkAddress> discoverFromAddressMultiplePorts(
    String address,
    List<int> ports, {
    Duration timeout = const Duration(seconds: 2),
  }) {
    return PortScanner.discoverFromAddressMultiplePorts(address, ports,
        timeout: timeout);
  }
}
