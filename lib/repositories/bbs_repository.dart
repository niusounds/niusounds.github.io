import '../models/bbs_entry.dart';

abstract class BbsRepository {
  Stream<List<BbsEntry>> entries();

  Future<void> save(BbsEntry entry);

  Future<void> delete(BbsEntry entry);
}
