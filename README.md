# network_discovery

Dart/Flutter library that allows to ping IP subnet and discover network devices.

Could be used to find available host or services like http server (e.g. on port 80) and any other services on local network.

The device should be connected to a Router (a.s WIFI or Wired connection).

The library tested on Android, iOS, Windows and Linux platforms should work on your mac but has not been tested.

## Getting Started

Check complete example in /example folder.

Discover network device ip address:

```dart
import 'package:network_discovery/network_discovery.dart';

// Must be async function
final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();
if(deviceIP.isNotEmpty){
    print(deviceIP);
    // Can use to get subnet from IP Address
    final String subnet = address.substring(0, address.lastIndexOf('.'));
}else{
    print("Couldn't get IP Address");
}
```
Discover an available port at a given address and port:
```dart
import 'package:network_discovery/network_discovery.dart';

// Must be async function
const port = 80;
final device = NetworkDiscovery.discoverFromAddress('192.168.0.1', port);
print(device.toString());
```
Discover available ports at a given address and various ports:
```dart
import 'package:network_discovery/network_discovery.dart';

// Must be async function
const List<int> ports = [80, 443, 445, 8080];
final device = await NetworkDiscovery.discoverFromAddressMultiplePorts('192.168.0.1', ports);
print(device.toString());
```

Discover available host on network in a given subnet:
```dart
import 'package:network_discovery/network_discovery.dart';

final stream = NetworkDiscovery.discoverAllPingableDevices('192.168.0');

int availableHost = 0;
stream.listen((HostActive host) {
    print('Found device: ${host.ip}, isActive: ${host.isActive}');
    if(host.isActive){
        found++;
    }
}).onDone(() => print('Finish. Available $availableHost host device(s)'));
```
Discover available network devices in a given subnet and port:
```dart
import 'package:network_discovery/network_discovery.dart';

const port = 80;
final stream = NetworkDiscovery.discover('192.168.0', port);

int found = 0;
stream.listen((NetworkAddress addr) {
    found++;
    print('Found device: ${addr.ip}:$port');
}).onDone(() => print('Finish. Found $found device(s)'));
```
Discover available network devices on a given subnet and various ports:
```dart
import 'package:network_discovery/network_discovery.dart';

const List<int> ports = [80, 443, 445, 8080];

final stream = NetworkDiscovery.discoverMultiplePorts('192.168.0', ports);

int found = 0;
stream.listen((NetworkAddress addr) {
    found++;
    print('Found device: ${addr.ip}:$port');
}).onDone(() => print('Finish. Found $found device(s)'));
```