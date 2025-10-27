class PolymorphicReference<T,ID> {
  
  final T type;
  final ID id;

  PolymorphicReference(this.type, this.id);

  @override
  String toString() {
    return 'PolymorphicReference{type: $type, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PolymorphicReference<T, ID>) return false;

    return other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
