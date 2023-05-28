//
//  NeomorphicButtons.swift
//  Flixer
//
//  Created by Julian Riemersma on 10/02/2021.
//

import SwiftUI

struct LightBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color(#colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.9215686275, alpha: 1)))
                    .overlay(
                        shape
                            .stroke(Color.gray, lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
                            .mask(shape.fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    )
                    .overlay(
                        shape
                            .stroke(Color.white, lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(shape.fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    )
            } else {
                shape
                    .fill(Color(#colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.9215686275, alpha: 1)))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}

struct LightButtonStyle<S: Shape>: ButtonStyle {
    var paddingSize: CGFloat = 30
    var shape: S

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(paddingSize)
            .contentShape(shape)
            .background(
                LightBackground(isHighlighted: configuration.isPressed, shape: shape)
            )
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1)), Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1)), radius: 10, x: 5, y: 5)
                    .shadow(color: Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1)), radius: 10, x: -5, y: -5)

            } else {
                shape
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1)), Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1)), radius: 10, x: -10, y: -10)
                    .shadow(color: Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1)), radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct DarkButtonStyle<S: Shape>: ButtonStyle {
    var paddingSize: CGFloat = 30
    var shape: S

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(paddingSize)
            .contentShape(shape)
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: shape)
            )
    }
}
