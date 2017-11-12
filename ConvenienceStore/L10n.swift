// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Common {

    enum Label {
      /// 閉じる
      static let close = L10n.tr("Localizable", "common.label.close")
      /// いいえ
      static let no = L10n.tr("Localizable", "common.label.no")
      /// はい
      static let yes = L10n.tr("Localizable", "common.label.yes")
    }

    enum Title {
      /// FamilyMart
      static let familymart = L10n.tr("Localizable", "common.title.familymart")
      /// ローソン
      static let lawson = L10n.tr("Localizable", "common.title.lawson")
      /// ｾﾌﾞﾝｲﾚﾌﾞﾝ
      static let seveneleven = L10n.tr("Localizable", "common.title.seveneleven")
    }
  }

  enum Itemdetail {

    enum Label {
      /// 違反報告
      static let report = L10n.tr("Localizable", "itemDetail.label.report")
      /// このコメントに対して違反報告をしますか？
      static let reportMessage = L10n.tr("Localizable", "itemDetail.label.reportMessage")
    }
  }

  enum Review {

    enum Label {
      /// 星をタップして評価してください
      static let reviewHelp = L10n.tr("Localizable", "review.label.reviewHelp")
      /// 送信
      static let send = L10n.tr("Localizable", "review.label.send")
      /// レビューを書く
      static let writeReview = L10n.tr("Localizable", "review.label.writeReview")
    }

    enum Template {
      /// 評価件数：%d
      static func reviewCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "review.template.reviewCount", p1)
      }
    }
  }

  enum Template {

    enum Label {
      /// %d円(税込)
      static func includeTaxPrice(_ p1: Int) -> String {
        return L10n.tr("Localizable", "template.label.includeTaxPrice", p1)
      }
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

