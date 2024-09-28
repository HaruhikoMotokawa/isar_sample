/// 並び替えの種類
///
/// - 名前の昇順
/// - 名前の降順
/// - 年齢の昇順
/// - 年齢の降順
/// - ホームタウン(昇順)
/// - ドラゴンボールキャラクター(昇順)
enum SortType {
  nameAsc('名前の昇順'),
  nameDesc('名前の降順'),
  ageAsc('年齢の昇順'),
  ageDesc('年齢の降順'),
  hometown('ホームタウン順'),
  dragonBallCharacter('ドラゴンボールキャラクター順');

  const SortType(this.description);

  /// 説明
  final String description;
}
