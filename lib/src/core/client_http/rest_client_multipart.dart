class RestClientMultipart {
  final String fileKey;
  final String fileName;
  final String path;
  final List<int>? fileBytes;

  RestClientMultipart({
    required this.fileKey,
    required this.fileName,
    required this.path,
    required this.fileBytes,
  });
}
