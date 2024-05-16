//
//  TestView.swift
//  Redefine
//
//  Created by Olaf Neumann on 15.05.24.
//

import SwiftUI

struct TestView: View {
    private let spotify = SpotifyConnector.shared
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button(action: {
                spotify.start() // connect()
            }, label: {
                Text("Connect")
            })
        }
    }
}

#Preview {
    TestView()
}
