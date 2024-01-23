abstract interface class ChecksumChecker {
  Future<String?> getChecksum();
  Future<void> setChecksum(String checksum);
  Future<void> dropChecksum();
}
