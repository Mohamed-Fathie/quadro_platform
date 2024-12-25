List<List<T>> splitIntoChunks<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(
      list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize),
    );
  }
  return chunks;
}
