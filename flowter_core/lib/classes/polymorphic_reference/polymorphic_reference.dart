class PolymorphicReference<A, B> {
  final A id;
  final B type;

  PolymorphicReference(this.id, this.type);

  @override
  String toString() {
    return 'PolymorphicReference{id: $id, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PolymorphicReference<A, B>) return false;

    return other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
