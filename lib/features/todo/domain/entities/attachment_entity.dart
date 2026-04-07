import 'dart:typed_data';
class AttachmentEntity {
  final String name;
  final String path;
  final int sizeInBytes;
  final Uint8List? bytes;

  const AttachmentEntity({
    required this.name,
    required this.path,
    required this.sizeInBytes,
    this.bytes,
  });

  AttachmentEntity copyWith({String? name, String? path, int? sizeInBytes, Uint8List? bytes}) =>
      AttachmentEntity(
        name: name ?? this.name,
        path: path ?? this.path,
        sizeInBytes: sizeInBytes ?? this.sizeInBytes,
        bytes: bytes ?? this.bytes,
      );
}