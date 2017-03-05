// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
// swiftlint:disable nesting
// swiftlint:disable variable_name
// swiftlint:disable valid_docs

enum L10n {

  enum Common {

    enum Label {
      /// 閉じる
      static let close = L10n.tr("common.label.close")
      /// いいえ
      static let no = L10n.tr("common.label.no")
      /// はい
      static let yes = L10n.tr("common.label.yes")
    }

    enum Title {
      /// FamilyMart
      static let familymart = L10n.tr("common.title.familymart")
      /// ローソン
      static let lawson = L10n.tr("common.title.lawson")
      /// ｾﾌﾞﾝｲﾚﾌﾞﾝ
      static let seveneleven = L10n.tr("common.title.seveneleven")
    }
  }

  enum Itemdetail {

    enum Label {
      /// 違反報告
      static let report = L10n.tr("itemDetail.label.report")
      /// このコメントに対して違反報告をしますか？
      static let reportMessage = L10n.tr("itemDetail.label.reportMessage")
    }
  }

  enum Review {

    enum Label {
      /// 星をタップして評価してください
      static let reviewHelp = L10n.tr("review.label.reviewHelp")
      /// 送信
      static let send = L10n.tr("review.label.send")
      /// レビューを書く
      static let writeReview = L10n.tr("review.label.writeReview")
    }

    enum Template {
      /// 評価件数：%d
      static func reviewCount(_ p1: Int) -> String {
        return L10n.tr("review.template.reviewCount", p1)
      }
    }
  }

  enum Template {

    enum Label {
      /// %d円(税込)
      static func includeTaxPrice(_ p1: Int) -> String {
        return L10n.tr("template.label.includeTaxPrice", p1)
      }
    }
  }
}

extension L10n {
  fileprivate static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:enable type_body_length
// swiftlint:enable nesting
// swiftlint:enable variable_name
// swiftlint:enable valid_docs

