import SwiftUI


struct loginButton: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10)
        {
            text("Login")
                .font(.system(size: 16,weight: .black))
                .foregroundColor(.white)
        }
        .padding(10)
        .frame(maxWidth:.infinity,minHeight: 48,alignment:.center)
        .background(.white.opacity(0.03))
        .cornerRadius(8)
    }
}