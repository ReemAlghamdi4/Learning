import SwiftUI

// This struct acts as a centralized library for all reusable styling components in the app.
struct StyleGuide {

    // MARK: - Pill Button Styles (from ContentView)
    
    enum PillTheme {
        // Base fill for the unselected pill (dark charcoal gradient)
        static var unselectedFill: LinearGradient {
            LinearGradient(
                colors: [
                    Color(white: 0.10),
                    Color(white: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        // Soft top-left white highlight used as a stroke
        static var unselectedHighlightStroke: LinearGradient {
            LinearGradient(
                colors: [
                    Color.white.opacity(0.40),
                    Color.white.opacity(0.40),
                    Color.white.opacity(0.40),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.20),
                    Color.white.opacity(0.40),
                ],
                startPoint: .topLeading,
                endPoint: .bottom
            )
        }

        // Soft bottom-right darker rim used as a stroke
        static var unselectedRimStroke: LinearGradient {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.40)
                ],
                startPoint: .center,
                endPoint: .bottomTrailing
            )
        }
    }

    static var unselectedPill: some View {
        let shape = RoundedRectangle(cornerRadius: 1000, style: .continuous)
        return shape
            .fill(PillTheme.unselectedFill)
            .overlay(
                shape
                    .strokeBorder(
                        PillTheme.unselectedHighlightStroke,
                        lineWidth: 1.0
                    )
            )
            .overlay(
                shape
                    .strokeBorder(
                        PillTheme.unselectedRimStroke,
                        lineWidth: 1.0
                    )
            )
    }
    
    static var selectedPill: some View {
        let shape = RoundedRectangle(cornerRadius: 1000, style: .continuous)
        return shape
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.76, green: 0.30, blue: 0.01),
                    ],
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
            )
            .overlay(
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.45),
                                Color.white.opacity(0.45),
                                Color.white.opacity(0.45),

                                Color.black.opacity(0.20),
                                Color.black.opacity(0.20),
                                Color.black.opacity(0.20),
                                Color.black.opacity(0.20),
                                Color.white.opacity(0.30),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .overlay(
                shape
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.0),
                                Color.black.opacity(0.28)
                            ],
                            startPoint: .center,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            )
    }

    // MARK: - General Styles (from Logday)

    static var graniteCircle: some View {
        Circle()
                // 1. The "Gray Effect" (tint)
                .fill(Color(white: 0.1, opacity: 0.2))
                
                // 2. The Glass (blur)
                .background(.regularMaterial)
                
                // 3. Clip the glass effect to the circle
                .clipShape(Circle())
                
                // 4. The "Glossy White Stroke"
                .overlay(
                    Circle()
                        .strokeBorder(
                            // Use a gradient for the "glossy" look
                            LinearGradient(
                                colors: [.gray, .black.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5 // Made slightly thicker to see the gloss
                        )
                )
                .frame(width: 44, height: 44)
    }
    static var mainCardBackground: some View {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
            .fill(Color(white: 0.1).opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.10),
                                Color.white.opacity(0.10),
                                Color.white.opacity(0.10),
                                Color.white.opacity(0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }

    static var logButtonCircle: some View {
        let shape = Circle()
        // --- ✅ Added explicit return ---
        return shape
            .fill(
                Color.orange.opacity(1)
                )
            .overlay(
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.25),
                                Color.black.opacity(0.8),
                                Color.white.opacity(0.60),
                                Color.white.opacity(0.3),
                                Color.orange.opacity(0.4)
                            ]),
                            center: .center
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.orange.opacity(0.25), radius: 20, x: 0, y: 10)
    }

    static var freezeButtonRectangle: some View {
        let rect = RoundedRectangle(cornerRadius: 1000, style: .continuous)
        // --- ✅ Added explicit return ---
        return rect
            .fill(Color.bluee)
            .overlay(
                rect
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.20),
                                Color.white.opacity(0.30),
                                Color.white.opacity(0.40),
                                Color.white.opacity(0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .frame(width: 246, height: 48)
    }
    
    static var learndeButtonCircle: some View {
        let shape = Circle()
        return shape
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color(red: 0, green: 0, blue: 0.05).opacity(0.1), // Subtle blue-ish black
                        Color.orange.opacity(0.06)
                    ]),
                    center: .bottomTrailing,
                    startRadius: 0,
                    endRadius: 100
                )
            )
            .overlay(
                shape.strokeBorder( // Apply strokeBorder directly to the shape
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.4),
                            Color.orange.opacity(0.25),
                            Color.black.opacity(0.8),
                            Color.white.opacity(0.3),
                            Color.orange.opacity(0),
                            Color.orange.opacity(0.4)
                        ]),
                        center: .center
                    ),
                    lineWidth: 2
                )
            )
            .shadow(color: Color.orange.opacity(0.25), radius: 20, x: 0, y: 10)
    }
    
    static var frozenDayCircle: some View {
            let shape = Circle()
            return shape
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.black,
                            Color(red: 0, green: 0, blue: 0.05).opacity(0.1), // Subtle blue-ish black
                            Color.blue.opacity(0.04)
                        ]),
                        center: .bottomTrailing,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color.blueButton.opacity(0.4),
                                    Color.blueButton.opacity(0.25),
                                    Color.blueButton.opacity(0.8),
                                    Color.white.opacity(0.10),
                                    Color.blueButton.opacity(0.3),
                                    Color.blueButton.opacity(0.4)
                                ]),
                                center: .center
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.blue.opacity(0.25), radius: 20, x: 0, y: 10)
        }
}
