//
//  main.swift
//  NonsenseSaver
//
//  Created by C.W. Betts on 2/11/16.
//
//

import Foundation

srandom(UInt32(0x7FFFFFFF & time(nil)))
let controller = NonsenseSaverController()
print(controller.randomSaying())
exit(EXIT_SUCCESS)
