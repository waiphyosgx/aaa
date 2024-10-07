bool isCurrentVerLatest(String currentVersionStr, String latestVersionStr) {
  List<String> latestVersionSplit = latestVersionStr.split('.');
  List<String> currentVersionSplit = currentVersionStr.split('.');
  int maxSize = latestVersionSplit.length > currentVersionSplit.length
      ? latestVersionSplit.length
      : currentVersionSplit.length;

  for (int i = 0; i < maxSize; i++) {
    int latestNum = i < latestVersionSplit.length
        ? int.tryParse(latestVersionSplit[i]) ?? getIntFromString(latestVersionSplit[i])
        : 0;

    int currentNum = i < currentVersionSplit.length
        ? int.tryParse(currentVersionSplit[i]) ?? getIntFromString(currentVersionSplit[i])
        : 0;

    if (currentNum > latestNum) {
      return true;
    } else if (currentNum < latestNum) {
      return false;
    }
  }
  return true; // Versions are equal
}
