//
//  ConfettiView.swift
//  OKTimer
//
//  Created by Developer on 12/24/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .cyan]
    
    var body: some View {
        print("🌟 DEBUG: ConfettiView body is being rendered")
        return GeometryReader { geometry in
            ZStack {
                // Confetti particles
                ForEach(particles.indices, id: \.self) { index in
                    ConfettiShape(type: particles[index].type)
                        .fill(particles[index].color)
                        .frame(width: particles[index].size, height: particles[index].size)
                        .position(particles[index].position)
                        .rotationEffect(.degrees(particles[index].rotation))
                        .opacity(particles[index].opacity)
                }
            }
            .onAppear {
                print("🎊 DEBUG: ConfettiView onAppear called - starting animation")
                startConfetti(in: geometry.size)
            }
        }
    }
    
    private func startConfetti(in size: CGSize) {
        // Generate particles
        for i in 0..<100 {
            let delay = Double(i) * 0.02
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let particle = ConfettiParticle(
                    position: CGPoint(x: CGFloat.random(in: 0...size.width), y: -20),
                    color: colors.randomElement() ?? .blue,
                    size: CGFloat.random(in: 8...16),
                    type: ConfettiShapeType.allCases.randomElement() ?? .circle
                )
                particles.append(particle)
                animateParticle(particle: particle, in: size)
            }
        }
    }
    
    private func animateParticle(particle: ConfettiParticle, in size: CGSize) {
        guard let index = particles.firstIndex(where: { $0.id == particle.id }) else { return }
        
        let duration = Double.random(in: 2.0...4.0)
        let endY = size.height + 50
        let drift = CGFloat.random(in: -100...100)
        
        withAnimation(.easeIn(duration: duration)) {
            particles[index].position.y = endY
            particles[index].position.x += drift
            particles[index].rotation = Double.random(in: 360...720)
            particles[index].opacity = 0
        }
        
        // Remove particle after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            particles.removeAll { $0.id == particle.id }
        }
    }
    
    private func startAnimation() {
        print("� DEBUG: ConfettiView startAnimation called - creating \(particles.count) particles")
        
        // First, make all particles visible and positioned at the top
        for i in particles.indices {
            particles[i].opacity = 1.0
            particles[i].position.y = -50 // Start above the view
        }
        
        // Then animate them falling down with different delays for staggered effect
        for i in particles.indices {
            let delay = Double.random(in: 0.0...0.5)
            let duration = Double.random(in: 2.0...4.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeIn(duration: duration)) {
                    self.particles[i].position.y += 1000 // Fall down past the bottom
                    self.particles[i].opacity = 0 // Fade out as they fall
                }
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let type: ConfettiShapeType
    var rotation: Double = 0
    var opacity: Double = 1.0
}

enum ConfettiShapeType: CaseIterable {
    case circle, square, triangle, star
}

struct ConfettiShape: Shape {
    let type: ConfettiShapeType
    
    func path(in rect: CGRect) -> Path {
        switch type {
        case .circle:
            return Path(ellipseIn: rect)
        case .square:
            return Path(rect)
        case .triangle:
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            return path
        case .star:
            return starPath(in: rect)
        }
    }
    
    private func starPath(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let angleIncrement = Double.pi * 2 / 5
        
        for i in 0..<5 {
            let outerAngle = Double(i) * angleIncrement - Double.pi / 2
            let innerAngle = outerAngle + angleIncrement / 2
            
            let outerPoint = CGPoint(
                x: center.x + cos(CGFloat(outerAngle)) * outerRadius,
                y: center.y + sin(CGFloat(outerAngle)) * outerRadius
            )
            let innerPoint = CGPoint(
                x: center.x + cos(CGFloat(innerAngle)) * innerRadius,
                y: center.y + sin(CGFloat(innerAngle)) * innerRadius
            )
            
            if i == 0 {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: outerPoint)
            }
            path.addLine(to: innerPoint)
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.black
        ConfettiView()
    }
}
