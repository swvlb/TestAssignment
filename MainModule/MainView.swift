import SwiftUI

struct MainView: View {

    @StateObject private var viewModel = MainViewModel()
    @State private var isLogoutConfirmationPresented = false

    let onLogout: () -> Void

    var body: some View {
        NavigationView {
            self.content
                .navigationTitle("Товары")
                .toolbar { self.toolbarContent }
                .task { await self.viewModel.loadProducts() }
                .sheet(isPresented: self.$viewModel.isGreetingPresented) {
                    GreetingModalView(text: self.viewModel.greetingText) {
                        self.viewModel.isGreetingPresented = false
                    }
                }
                .alert("Выйти из аккаунта?", isPresented: self.$isLogoutConfirmationPresented) {
                    Button("Выйти", role: .destructive) {
                        self.viewModel.logout()
                        self.onLogout()
                    }
                    Button("Отмена", role: .cancel) {}
                } message: {
                    Text("Вам потребуется зарегистрироваться заново.")
                }
        }
    }
}

// MARK: - Content

private extension MainView {

    @ViewBuilder
    var content: some View {
        switch self.viewModel.loadState {
        case .idle, .loading:
            self.loadingView
        case .failed(let message):
            self.errorView(message: message)
        case .loaded:
            self.productsList
        }
    }

    var loadingView: some View {
        ProgressView("Загрузка...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button("Повторить") {
                Task { await self.viewModel.loadProducts() }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var productsList: some View {
        List(self.viewModel.products) { product in
            ProductRow(product: product)
        }
        .listStyle(.plain)
    }
}

// MARK: - Toolbar

private extension MainView {

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Выйти", role: .destructive) {
                self.isLogoutConfirmationPresented = true
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Приветствие", action: self.viewModel.showGreeting)
        }
    }
}

// MARK: - Product row

struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            ProductThumbnail(url: self.product.imageURL)

            VStack(alignment: .leading, spacing: 4) {
                Text(self.product.title)
                    .font(.body)
                    .lineLimit(2)
                if let category = self.product.category {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text(self.product.formattedPrice)
                .font(.headline)
                .foregroundColor(AppTheme.primary)
        }
        .padding(.vertical, 4)
    }
}

struct ProductThumbnail: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: self.url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fit)
            case .failure:
                self.placeholder(systemName: "photo")
            case .empty:
                self.placeholder(systemName: nil)
            @unknown default:
                self.placeholder(systemName: "photo")
            }
        }
        .frame(width: 48, height: 48)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }

    @ViewBuilder
    private func placeholder(systemName: String?) -> some View {
        if let systemName {
            Image(systemName: systemName).foregroundColor(.secondary)
        } else {
            ProgressView()
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(onLogout: {})
    }
}
#endif
