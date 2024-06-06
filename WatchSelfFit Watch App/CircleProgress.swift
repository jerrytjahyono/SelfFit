//
//  CircleProgress.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 06/06/24.
//

import SwiftUI

struct CircleProgress: View {
    var progress: Float
//    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            // Gray circle
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
                .foregroundColor(.gray)

             // Orange circle
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0,
                    lineCap: .round, lineJoin: .round))
                .foregroundColor(.orange)
                // Ensures the animation starts from 12 o'clock
                .rotationEffect(Angle(degrees: 270))
        }
        // The progress animation will animate over 1 second which
        // allows for a continuous smooth update of the ProgressView
        .animation(.linear(duration: 1.0), value: progress)
    }
}

#Preview {
    CircleProgress(progress: 0.6)
}
