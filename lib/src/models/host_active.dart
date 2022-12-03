class HostActive {
  final String ip;
  final bool isActive;
  const HostActive(this.ip, this.isActive);
  @override
  String toString() {
    return "Instance of 'HostActive(ip:$ip, isActive:$isActive);'";
  }
}
