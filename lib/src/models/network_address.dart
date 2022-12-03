class NetworkAddress {
  NetworkAddress(this.ip, {required this.openPorts});
  String ip;
  List<int> openPorts;

  @override
  String toString() {
    return "Instance of 'NetworkAddress(ip:$ip, openPort: ${openPorts.toList()});'";
  }
}
