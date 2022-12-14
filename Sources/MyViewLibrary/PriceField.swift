//
//  PriceField.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

public struct PriceField<L: View>: View {
    @Binding var value: Int
    var positiveOnly = false
    var label: () -> L
    var onlyShowKeypadWhenEditing: Bool
    @State private var isEditing = false
    
    private let hapic = UIImpactFeedbackGenerator(style: .medium)
    
    public init(value: Binding<Int>,
                positiveOnly: Bool = false,
                label: @escaping () -> L,
                isEditing: Bool = false,
                onlyShowKeypadWhenEditing: Bool = false
    ) {
        self._value = value
        self.positiveOnly = positiveOnly
        self.label = label
        self.onlyShowKeypadWhenEditing = onlyShowKeypadWhenEditing
    }
        
    public var body: some View {
        VStack {
            HStack {
                label()
                Spacer()
                Button {
                    isEditing.toggle()
                } label: {
                    CurrencyText(value)
                        .padding(8)
                        .background {
                            Color(uiColor: .tertiarySystemFill)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            if !onlyShowKeypadWhenEditing || isEditing {
                HStack {
                    digitButton(val: 1)
                    digitButton(val: 2)
                    digitButton(val: 3)
                }
                HStack {
                    digitButton(val: 4)
                    digitButton(val: 5)
                    digitButton(val: 6)
                }
                HStack {
                    digitButton(val: 7)
                    digitButton(val: 8)
                    digitButton(val: 9)
                }
                HStack {
                    Button {
                        value = value * 100
                        hapic.impactOccurred()
                    } label: {
                        buttonLabel(text: "00")
                    }
                    digitButton(val: 0)
                    HStack {
                        if !positiveOnly {
                            Button {
                                value = -value
                            } label: {
                                buttonLabel(text: "-/+")
                            }
                        }
                        Button {
                            value = 0
                            hapic.impactOccurred()
                        } label: {
                            buttonLabel(text: "归零")
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func buttonLabel(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .foregroundColor(Color(uiColor: .tertiarySystemFill))
            Text(text)
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    func digitButton(val: Int) -> some View {
        Button {
            if value == 0 {
                if positiveOnly {
                    value = val
                } else {
                    value = -val
                }
            } else if value > 0 {
                value = 10 * value + val
            } else {
                value = 10 * value - val
            }
            hapic.impactOccurred()
        } label: {
            buttonLabel(text: "\(val)")
        }
    }
}

struct PriceField_Previews: PreviewProvider {
    @State static var value = 1234
    
    static var previews: some View {
        PriceField(value: $value) {
            Text("Value")
        }
    }
}
