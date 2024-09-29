/// 絞り込み条件の種類
///
/// - 若者18~29歳
/// - 中年30~49歳
/// - 高齢50歳以上
///
/// - 出身地が札幌
/// - 出身地が仙台
/// - 出身地が東京
/// - 出身地が大阪
/// - 出身地が京都
/// - 出身地が福岡
///
/// - 犬を飼っている
/// - 猫を飼っている
/// - ウサギを飼っている
/// - オウムを飼っている
/// - ハムスターを飼っている
enum FilterType {
  young('若者18~29歳'),
  middleAged('中年30~49歳'),
  elderly('高齢50歳以上'),
  originSapporo('出身地が札幌'),
  originSendai('出身地が仙台'),
  originTokyo('出身地が東京'),
  originOsaka('出身地が大阪'),
  originKyoto('出身地が京都'),
  originFukuoka('出身地が福岡'),
  ownsDog('犬を飼っている'),
  ownsCat('猫を飼っている'),
  ownsRabbit('ウサギを飼っている'),
  ownsParrot('オウムを飼っている'),
  ownsHamster('ハムスターを飼っている'),
  ;

  const FilterType(this.description);

  final String description;
}
