part of 'extensions.dart';

extension MapEntryFunctions<K, V> on MapEntry<K, V> {

  MapEntry<V,K> swap() {
    return MapEntry(value, key);
  }

}