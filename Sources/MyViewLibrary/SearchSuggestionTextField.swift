//
//  SearchSuggestionTextField.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/9.
//

import SwiftUI

public struct SearchSuggestionTextField: View {
    var label: String?
    @Binding var text: String
    var suggestions: [String]
    private var showSuggestionOnlyWhenEditing: Bool
    @FocusState private var focused: Bool
    
    public init(_ label: String?,
                text: Binding<String>,
                suggestions: [String],
                showSuggestionOnlyWhenEditing: Bool = true
    ) {
        self.label = label
        self._text = text
        self.suggestions = suggestions
        self.showSuggestionOnlyWhenEditing = showSuggestionOnlyWhenEditing
    }
    
    @State private var editingText = ""
    
    public var body: some View {
        VStack {
            HStack {
                if label != nil {
                    Text(label!)
                    Spacer()
                }
                TextField("", text: $editingText)
                    .focused($focused)
                    .onSubmit {
                        text = editingText
                    }
                    .transformEnvironment(\.layoutDirection) { direction in
                        if label == nil {
                            return
                        } else if direction == .leftToRight {
                            direction = .rightToLeft
                            return
                        } else {
                            direction = .leftToRight
                            return
                        }
                    }
            }
            if !showSuggestionOnlyWhenEditing || focused {
                FlowHStack {
                    ForEach(suggestions, id: \.self) { suggest in
                        if suggest != "" {
                            if text == suggest {
                                Button(suggest) {
                                    setText(to: suggest)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                            } else {
                                Button(suggest) {
                                    setText(to: suggest)
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .tint(.primary)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            editingText = text
        }
    }
    
    private func setText(to newValue: String) {
        text = newValue
        editingText = newValue
        if showSuggestionOnlyWhenEditing {
            focused = false
        }
    }
}

public struct SearchSuggestionTextPage: View {
    @Binding var text: String
    var suggestions: [String]
    
    public init(text: Binding<String>, suggestions: [String]) {
        self._text = text
        self.suggestions = suggestions
    }
    
    @State private var editingText = ""
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("建议")
                .bold()
            if suggestions.isEmpty {
                Text("没有建议内容，请在下方直接输入。")
            }
            ScrollView {
                FlowHStack {
                    ForEach(suggestions, id: \.self) { suggest in
                        if suggest != "" {
                            if text == suggest {
                                Button(suggest) {
                                    setText(to: suggest)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                            } else {
                                Button(suggest) {
                                    setText(to: suggest)
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .tint(.primary)
                            }
                        }
                    }
                }
            }
            Text("其他")
                .bold()
            HStack {
                TextField("", text: $editingText)
                    .focused($focused)
                    .onSubmit {
                        text = editingText
                        dismiss()
                }
                Button {
                    text = ""
                    editingText = ""
                    focused = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }.tint(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
                Color(uiColor: .secondarySystemGroupedBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding()
        .background {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
        }
        .onAppear {
            editingText = text
        }
        .interactiveDismissDisabled(focused)
    }
    
    private func setText(to newValue: String) {
        text = newValue
        editingText = newValue
        focused = false
        dismiss()
    }
}

public struct SearchSuggestionTextFieldButton: View {
    var label: String?
    @Binding var text: String
    var suggestions: [String]
    
    public init(_ label: String? = nil,
                text: Binding<String>,
                suggestions: [String]
    ) {
        self.label = label
        self._text = text
        self.suggestions = suggestions
    }
    
    @State private var isEditing = false
    
    public var body: some View {
        Button {
            isEditing = true
        } label: {
            HStack {
                if label != nil {
                    Text(label!)
                    Spacer()
                }
                Text(text)
            }
        }
        .tint(.primary)
        .sheet(isPresented: $isEditing, content: {
            SearchSuggestionTextPage(text: $text, suggestions: suggestions)
        })
    }
}

struct SearchSuggestionTextField_Previews: PreviewProvider {
    @State private static var text = "麦当劳"
    @State private static var suggestions = ["struct", "PreviewProvider", "菜", "吃席", "KFC", "麦当劳", "紫菜蛋花汤", "滚蛋汤"]

    static var previews: some View {
        NavigationStack {
            Form {
                SearchSuggestionTextFieldButton("SearchText", text: $text, suggestions: suggestions)
                SearchSuggestionTextFieldButton(text: $text, suggestions: suggestions)
                SearchSuggestionTextFieldButton("无建议文本框", text: $text, suggestions: [])
            }
            .navigationTitle("Form")
            //SearchSuggestionTextPage("菜品", text: $text, suggestions: suggestions)
        }
    }
}
