// FloatingPoint.swift
// swift-standards
//
// Extensions for Swift standard library FloatingPoint protocol

extension FloatingPoint {
    /// Tests approximate equality within tolerance
    ///
    /// Compares floating-point values with epsilon tolerance.
    /// Essential for numerical computing due to rounding errors.
    ///
    /// Category theory: Equivalence relation in metric space (ℝ, d)
    /// where d(x, y) ≤ ε defines equivalence classes
    ///
    /// Example:
    /// ```swift
    /// let a = 0.1 + 0.2
    /// let b = 0.3
    /// a.isApproximatelyEqual(to: b, tolerance: 0.0001)  // true
    /// a == b  // false (due to floating-point representation)
    /// ```
    public func isApproximatelyEqual(to other: Self, tolerance: Self) -> Bool {
        abs(self - other) <= tolerance
    }

    /// Linear interpolation between two values
    ///
    /// Computes point along line segment from self to other.
    /// Parameter t ∈ [0, 1] determines position (0 = self, 1 = other).
    ///
    /// Category theory: Affine combination in vector space
    /// lerp: ℝ × ℝ × [0,1] → ℝ where lerp(a, b, t) = a + t(b - a)
    /// Satisfies: lerp(a, b, 0) = a, lerp(a, b, 1) = b, lerp is continuous
    ///
    /// Example:
    /// ```swift
    /// let a = 0.0
    /// let b = 10.0
    /// a.lerp(to: b, t: 0.5)  // 5.0 (midpoint)
    /// a.lerp(to: b, t: 0.25) // 2.5 (quarter way)
    /// ```
    public func lerp(to other: Self, t: Self) -> Self {
        self + t * (other - self)
    }

    /// Rounds to specified decimal places
    ///
    /// Quantization morphism to discrete subset.
    /// Projects continuous reals onto decimal lattice.
    ///
    /// Category theory: Quotient morphism ℝ → ℝ/~
    /// where x ~ y iff round(x, n) = round(y, n)
    ///
    /// Example:
    /// ```swift
    /// let pi: Double = 3.14159265359
    /// pi.rounded(to: 2)  // 3.14
    /// pi.rounded(to: 4)  // 3.1416
    /// ```
    public func rounded(to places: Int) -> Self {
        guard places >= 0 else { return self }
        var divisor: Self = 1
        for _ in 0..<places {
            divisor *= 10
        }
        return (self * divisor).rounded() / divisor
    }

    /// Clamps value to unit interval [0, 1]
    ///
    /// Common operation in graphics, color spaces, and normalized computations.
    /// Restricts value to valid probability/percentage range.
    ///
    /// Category theory: Restriction morphism to unit interval
    /// clamp01: ℝ → [0,1]
    ///
    /// Example:
    /// ```swift
    /// 0.5.clamp01()   // 0.5
    /// 1.5.clamp01()   // 1.0
    /// (-0.5).clamp01() // 0.0
    /// ```
    public func clamp01() -> Self {
        if self < 0 { return 0 }
        if self > 1 { return 1 }
        return self
    }
}
