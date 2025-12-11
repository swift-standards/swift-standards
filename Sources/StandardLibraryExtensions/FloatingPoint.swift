// FloatingPoint.swift
// swift-standards
//
// Extensions for Swift standard library FloatingPoint protocol

extension FloatingPoint {
    /// Returns `true` if the values are approximately equal within the specified tolerance.
    ///
    /// Use this for comparing floating-point values where exact equality is unreliable due to rounding errors.
    /// The tolerance determines the maximum acceptable difference.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a = 0.1 + 0.2
    /// let b = 0.3
    /// a.isApproximatelyEqual(to: b, tolerance: 0.0001)  // true
    /// a == b  // false
    /// ```
    public func isApproximatelyEqual(to other: Self, tolerance: Self) -> Bool {
        abs(self - other) <= tolerance
    }

    /// Returns the linear interpolation between this value and another.
    ///
    /// Computes a point along the line from this value to the other value, where `t` determines the position.
    /// When `t` is 0, returns this value; when `t` is 1, returns the other value; values between 0 and 1 interpolate proportionally.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a = 0.0
    /// let b = 10.0
    /// a.lerp(to: b, t: 0.5)  // 5.0
    /// a.lerp(to: b, t: 0.25) // 2.5
    /// ```
    public func lerp(to other: Self, t: Self) -> Self {
        self + t * (other - self)
    }

    /// Returns the value raised to the specified integer power.
    ///
    /// Uses exponentiation by squaring for efficient computation. More performant than `pow()` for integer exponents.
    /// Use this when you need to raise a floating-point value to a whole number power.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 2.0.power(10)   // 1024.0
    /// 10.0.power(3)   // 1000.0
    /// 0.5.power(4)    // 0.0625
    /// ```
    public func power(_ exponent: Int) -> Self {
        guard exponent > 0 else { return exponent == 0 ? 1 : 0 }

        var result: Self = 1
        var base = self
        var n = exponent

        // Fast exponentiation by squaring: O(log n)
        while n > 0 {
            if n & 1 == 1 {
                result *= base
            }
            base *= base
            n >>= 1
        }
        return result
    }

    /// Returns the value rounded to the specified number of decimal places.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pi: Double = 3.14159265359
    /// pi.rounded(to: 2)  // 3.14
    /// pi.rounded(to: 4)  // 3.1416
    /// ```
    public func rounded(to places: Int) -> Self {
        guard places >= 0 else { return self }
        let divisor = Self(10).power(places)
        return (self * divisor).rounded() / divisor
    }
}
