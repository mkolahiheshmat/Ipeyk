//
//  LanguageExtension.swift
//  PeikYab
//
//  Created by Developer on 1/4/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import Foundation

extension String {
    func language() -> String? {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = self
        return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
    }
}
