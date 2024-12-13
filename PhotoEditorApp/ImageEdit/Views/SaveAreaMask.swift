//
//  SaveAreaMask.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 13/12/24.
//

import SwiftUI

struct SaveAreaMask: View {
    let size: CGSize
    let saveRect: CGRect
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.1)
                .frame(width: size.width, height: size.height)
            
            Rectangle()
                .frame(width: saveRect.width, height: saveRect.height)
                .position(x: saveRect.midX, y: saveRect.midY)
                .foregroundColor(.clear)
        }
        .mask(
            Rectangle()
                .frame(width: size.width, height: size.height)
                .position(x: size.width / 2, y: size.height / 2)
        )
    }
}
