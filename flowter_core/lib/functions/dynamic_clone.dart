dynamic dynamicClone<T>(dynamic original) {
  if (original is List) {
    // Clone a list and its elements recursively
    return original.map((item) => dynamicClone(item)).toList();
  } else if (original is Map) {
    // Clone a map and its values recursively
    return original.map((key, value) => MapEntry(dynamicClone(key), dynamicClone(value)));
  } else {
    // For non-list and non-map types, return the original value
    return original;
  }
}