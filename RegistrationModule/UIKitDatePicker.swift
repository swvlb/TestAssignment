import SwiftUI
import UIKit

// UIDatePicker внутри SwiftUI: компактный стиль, по тапу разворачивается календарь.
struct UIKitDatePicker: UIViewRepresentable {

    @Binding var date: Date
    var maximumDate: Date = Date()
    var minimumDate: Date? = Calendar.current.date(byAdding: .year, value: -120, to: Date())

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        // Стандартный системный акцент (синий), как на макете, а не красная тема приложения.
        picker.tintColor = .systemBlue
        picker.maximumDate = self.maximumDate
        picker.minimumDate = self.minimumDate
        picker.setContentHuggingPriority(.required, for: .horizontal)
        picker.setContentCompressionResistancePriority(.required, for: .horizontal)
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.dateChanged(_:)),
            for: .valueChanged
        )
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        if uiView.date != self.date {
            uiView.date = self.date
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension UIKitDatePicker {

    final class Coordinator: NSObject {
        private let parent: UIKitDatePicker

        init(_ parent: UIKitDatePicker) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            self.parent.date = sender.date
        }
    }
}
