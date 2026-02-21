abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> upsert(T entry);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
}
