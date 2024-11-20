//
//  horisontalScroll.swift
//  new_final
//
//  Created by Alumno on 13/11/24.
//

import SwiftUI


struct FirstControl: View {
    @State private var currentPage = 0
    private let images = ["wild", "puss"]
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 340, height: 187)
                        .clipped()
                        .cornerRadius(10)
                        .tag(index)
                        .onTapGesture {
                            path.append(AppRoute.movieDetail(index))
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 187)
            
            PageControl(numberOfPages: images.count, currentPage: $currentPage)
                .frame(height: 20)
                .padding(.top, 10)
        }
        .padding(0)
    }
}

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPage = currentPage
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged
        )
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
#Preview {
    FirstControl()
}
