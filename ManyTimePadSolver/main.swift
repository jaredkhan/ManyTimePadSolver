//
//  main.swift
//  ManyTimePadSolver
//
//  Created by Jared Khan on 18/06/2016.
//  Copyright © 2016 Jared Khan. All rights reserved.
//

import Foundation
import Darwin



let ciphertexts = [
    "0a56a84fae86dcabdf775a29bd7a3a0c199afbc6510b4c6db9",
    "0e52a80eae869fbdd56d5d2ff86d3610109af3db12446464f6",
    "0a56a84fae86dcabdf775a2bb96a200b13c8f69502582a30e4",
    "1051af00b99a9faad26c0f37bc392019199ae6dd02582a6cb3",
    "171eac02fd84d0b0d4645a2fb739271910d6b2cc045e2a72b9"
]

let manyTimePadSolver = ManyTimePadSolver(ciphertexts: ciphertexts)
manyTimePadSolver.interactiveMode()
