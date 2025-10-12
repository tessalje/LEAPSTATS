////
////  Extensions.swift
////  projServeLeaps
////
////  Created by Tessa on 14/7/25.
////
//
//import SwiftUI
//
//extension View {
//    @ViewBuilder
//    func addSpotlight(_ id: Int, shape: SpotlightShape = .rectangle, roundedRadius: CGFloat = 0, text: String = "")->some View {
//        self
//    }
//}
//
//enum SpotlightShape {
//    case circle
//    case rectangle
//    case rounded
//}
//
//
//struct Spotlight_Preview: PreviewProvider {
//    static var previews: some View {
//        HomeTutorialView()
//    }
//}
//
////
////extension View {
////    func spotlight(enabled: Bool, title: String = "") -> some View {
////        return self
////            .overlay {
////                if enabled {
////                    GeometryReader {proxy in
////                        let rect = proxy.frame(in: .global)
////                        SpotlightView(rect: rect, title: title) {
////                            self
////                        }
////                    }
////                }
////            }
////    }
////    
////    func screenBounds()->CGRect {
////        return UIScreen.main.bounds
////    }
////    
////    func rootController()->UIViewController {
////        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
////            return .init()
////        }
////        guard let root = screen.windows.first?.rootViewController else {
////            return .init()
////        }
////        
////        return root
////    }
////}
////
////struct HomeTutorialView_Spotlight_Preview: PreviewProvider {
////    static var previews: some View {
////        HomeTutorialView()
////    }
////}
////
////struct SpotlightView<Content: View>: View {
////    var content: Content
////    var rect:CGRect
////    var title: String
////    
////    init(rect: CGRect, title:String, @ViewBuilder content: @escaping()->Content) {
////        self.content = content()
////        self.title = title
////        self.rect = rect
////    }
////    
////    @State var tag: Int = 1009
////    
////    var body: some View {
////        Rectangle()
////            .fill(.clear)
////            .onAppear() {
////                addOverlayView()
////            }
////            .onDisappear() {
////                removeOverlayView()
////            }
////    }
////    
////    func removeOverlayView() {
////        rootController().view.subviews.forEach{ view in
////            if view.tag == self.tag{
////                view.removeFromSuperview()
////            }
////        }
////    }
////    
////    func addOverlayView() {
////        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
////        hostingView.view.frame = screenBounds()
////        hostingView.view.backgroundColor = .clear
////        
////        if self.tag == 1009{
////            self.tag = generatedRandom()
////        }
////        hostingView.view.tag = self.tag
////        
////        rootController().view.subviews.forEach{ view in
////            if view.tag == self.tag{return}
////        }
////        
////        rootController().view.addSubview(hostingView.view)
////    }
////    
////    @ViewBuilder
////    func overlaySwiftUIView() -> some View {
////        ZStack {
////            Rectangle()
////                .fill(Color(.black).opacity(0.5))
////                .mask({
////                    let radius = (rect.height / rect.width) > 0.7 ? rect.width : 6
////                    Rectangle()
////                        .overlay {
////                            content
////                                .frame(width: rect.width, height: rect.height)
////                                .padding()
////                                .background(.white, in: RoundedRectangle(cornerRadius: radius))
////                                .position()
////                                .offset(x: rect.midX, y: rect.midY)
////                                .blendMode(.destinationOut)
////                        }
////                })
////                    
////            if title != "" {
////                Text(title)
////                    .font(.title.bold())
////                    .foregroundStyle(.white)
////                    .position()
////                    .offset(x: screenBounds().midX,
////                            y: rect.maxY > (screenBounds().height - 150) ?
////                            (rect.minY - 150) : (rect.maxY + 150))
////                    .padding()
////                    .lineLimit(2)
////            }
////        }
////        .frame(width: screenBounds().width, height: screenBounds().height)
////        .ignoresSafeArea()
////    }
////    
////    func generatedRandom()->Int {
////        let random = Int(UUID().uuid.0)
////        
////        let subViews = rootController().view.subviews
////        
////        for index in subViews.indices{
////            if subViews[index].tag == random{
////                return generatedRandom()
////            }
////        }
////        return random
////    }
////}
