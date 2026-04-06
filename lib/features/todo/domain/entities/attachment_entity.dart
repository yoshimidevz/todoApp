class AttachmentEntity {
  final String name;
  final String path;
  final int sizeInBytes;

  const AttachmentEntity({
    required this.name,
    required this.path,
    required this.sizeInBytes,
  });

  AttachmentEntity copyWith({String? name, String? path, int? sizeInBytes}) =>
      AttachmentEntity(
        name: name ?? this.name,
        path: path ?? this.path,
        sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      );
}