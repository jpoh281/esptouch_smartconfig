class ESPTouchResult {
  /// IP address of the connected device on the local network in string representation.
  ///
  /// Example: 127.0.0.55
  final String ip;

  /// BSSID (MAC address) of the connected device.
  ///
  /// Example: `ab:cd:ef:c0:ff:33`, or without colons `abcdefc0ff33`
  final String bssid;

  /// Create ESPTouchResult
  ESPTouchResult(this.ip, this.bssid);

  /// Create strongly-typed ESPTouchResult instance from a map.
  ESPTouchResult.fromMap(Map<dynamic, dynamic> m)
      : ip = m['ip'],
        bssid = m['bssid'];

  /// We provide == operator implementation: if two results have the same IP
  /// and BSSID, we consider them the same.
  ///
  /// This can be useful when working with sets, maps, etc... where equality check becomes important
  @override
  bool operator ==(o) => o is ESPTouchResult && o.ip == ip && o.bssid == bssid;

  /// We provide a hashcode implementation.
  ///
  /// This can be useful when working with sets, maps, etc... where equality check becomes important
  @override
  int get hashCode => ip.hashCode ^ bssid.hashCode;
}
