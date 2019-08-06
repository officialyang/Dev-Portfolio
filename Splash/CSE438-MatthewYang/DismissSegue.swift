//
//  DismissSegue.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/25/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
