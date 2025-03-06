//
//  RemoteImageView.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2024-01-20.
//

import SwiftUI

struct RemoteImageView: View {
    private var url: URL?
    private var placeholderColor: Color = .gray
    @State private var image: UIImage?
    @State private var loading: Bool

    init(url: URL?) {
        self.url = url
        
        if let url {
            if let cachedImage = UIImage.cachedImage(forURL: url) {
                self._image = State(initialValue: cachedImage)
                self._loading = State(initialValue: false)
            } else {
                self._image = State(initialValue: nil)
                self._loading = State(initialValue: true)
            }
        } else {
            self._image = State(initialValue: nil)
            self._loading = State(initialValue: false)
        }
    }

    func loadRemote() async throws {
        if self.image == nil, let url {
            let loadedImage = try await UIImage.load(fromURL: url)
            self.image = loadedImage
        }
    }
    
    var body: some View {
        SwiftUI.Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loading {
                Rectangle()
                    .fill(placeholderColor)
            } else {
                Rectangle()
                    .fill(.red)
            }
        }
        .geometryGroup()
        .task {
            try? await loadRemote()
            loading = false
        }
    }
}

#Preview {
    RemoteImageView(url: URL(string: "https://johanneswarn.com/johannesdagbok/bilder/32038575_193846654577815_3036008688146972672_n.jpg")!)
}
