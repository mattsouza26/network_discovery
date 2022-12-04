# network_discovery

Dart/Flutter library that allows to ping IP subnet and discover network devices.

Could be used to find printers (for example, on port 9100) and any other devices and services in local network.

The device should be connected to a Router.

The library tested on Android,iOS, Windows and Linux platforms, should work on yours mac but not tested.

## Getting Started

Check complete example in /example folder.

Discover network device ip address:

```dart
import 'package:network_discovery/network_discovery.dart';

// Must be async function
final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();
if(deviceIP.isNotEmpty){
    debugPrint(deviceIP);
    // Can use to get subnet from IP Address
    final String subnet = address.substring(0, address.lastIndexOf('.'));
}else{
    debugPrint("Couldn't get IP Address");
}
```

Discover available host on network devices in a given subnet:
```dart
import 'package:network_discovery/network_discovery.dart';

final stream = NetworkDiscovery.discoverAllPingableDevices('192.168.0');

int availableHost = 0;
stream.listen((HostActive host) {
    print('Found device: ${host.ip}, isActive: ${host.isActive}');
    if(host.isActive)
        found++;
}).onDone(() => print('Finish. Available $availableHost host device(s)'));
```

Discover available network devices in a given subnet on a given port:
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

Discover available network devices in a given subnet on a multiple given port:
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