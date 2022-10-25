class AudioModel {
  final int id;
  final String name;
  final String path;

  AudioModel({
    required this.id,
    required this.name,
    required this.path,
  });

  AudioModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        path = res['path'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'path': path,
    };
  }
}
