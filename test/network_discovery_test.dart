void main() async {
  // String address = '192.168.1.150';

  // print(Utils.isValidAddress(address));

  // group('Testing Host Scanner', () {
  //   test('Running getMaxHost tests', () {
  //     expect(HostScanner.getMaxHost("10.0.0.0"), HostScanner.classASubnets);
  //     expect(HostScanner.getMaxHost("164.0.0.0"), HostScanner.classBSubnets);
  //     expect(HostScanner.getMaxHost("200.0.0.0"), HostScanner.classCSubnets);
  //   });
  // });
  // String address = '192.168.1.150';
  // final String subnet = address.substring(0, address.lastIndexOf('.'));
  // final host = HostScanner.getAllPingableDevices(subnet);
  // List<HostActive> hostActive = [];
  // List<NetworkAddress> listNetworkAddress = [];
  // await host.listen((event) {
  //   if (event.isActive) {
  //     hostActive.add(event);
  //   }
  // }).asFuture();

  // print(hostActive);
  // final ports = PortScanner.discoverMultiplePorts(subnet, [13579]);
  // await ports.listen((event) {
  //   listNetworkAddress.add(event);
  // }).asFuture();
  // print(listNetworkAddress);

  // final stream = PortScanner.discoverFromHostMultiplePorts(
  //     address, List.generate(1024, (index) => index * 20));
  // await stream.listen((host) {
  //   //Same host can be emitted multiple times
  //   //Use Set<ActiveHost> instead of List<ActiveHost>
  //   print(host);
  // }, onDone: () {
  //   print('Scan completed');
  // }).asFuture();

  // or You can also get address using network_info_plus package
  // final String? address = await (NetworkInfo().getWifiIP());
  // final String subnet = address.substring(0, address.lastIndexOf('.'));
  // print(await HostScanner.getHostFromPing(address, const Duration(seconds: 5)));

  // final oldNet = NetworkAddress("192.168.1.150", openPorts: []);
  // final newNet = NetworkAddress("192.168.1.150", openPorts: [2]);
  // print(oldNet == newNet);
}
