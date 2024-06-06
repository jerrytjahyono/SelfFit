//
//  HistoryRow.swift
//  WatchSelfFit Watch App
//
//  Created by MacBook Pro on 05/06/24.
//

import SwiftUI

struct HistoryRow: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Leg Raise")
                Text("17 Jun 2022")
                    .font(.subheadline)
                    .fontWeight(.thin)
            }
            Spacer()
        }
    }
}

#Preview {
    HistoryRow()
}
