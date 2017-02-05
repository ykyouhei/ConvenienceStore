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

    enum Title {
      /// FamilyMart
      static let familymart = L10n.tr("common.title.familymart")
      /// ｾﾌﾞﾝｲﾚﾌﾞ
      static let seveneleven = L10n.tr("common.title.seveneleven")
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

