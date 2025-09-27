Map<B, Map<A, C>> transformMap<A, B, C>(Map<A, Map<B, C>> originalMap) {
  Map<B, Map<A, C>> newMap = {};

  originalMap.forEach((keyA, nestedMap) {
    nestedMap.forEach((keyB, value) {
      if (!newMap.containsKey(keyB)) {
        newMap[keyB] = {};
      }
      newMap[keyB]![keyA] = value;
    });
  });

  return newMap;
}