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

extension FilterTypeExtension on FilterType {
  bool get isAgeCategory {
    switch (this) {
      case FilterType.young:
      case FilterType.middleAged:
      case FilterType.elderly:
        return true;
      case _:
        return false;
    }
  }

  bool get isOrigin {
    switch (this) {
      case FilterType.originSapporo:
      case FilterType.originSendai:
      case FilterType.originTokyo:
      case FilterType.originOsaka:
      case FilterType.originKyoto:
      case FilterType.originFukuoka:
        return true;
      case _:
        return false;
    }
  }

  bool get isPet {
    switch (this) {
      case FilterType.ownsDog:
      case FilterType.ownsCat:
      case FilterType.ownsRabbit:
      case FilterType.ownsParrot:
      case FilterType.ownsHamster:
        return true;
      case _:
        return false;
    }
  }
}

extension FilterTypeListExtension on Iterable<FilterType> {
  List<FilterType> get filterByAgeCategory =>
      where((type) => type.isAgeCategory).toList();
  List<FilterType> get filterByOrigin =>
      where((type) => type.isOrigin).toList();
  List<FilterType> get filterByPet => where((type) => type.isPet).toList();
}
