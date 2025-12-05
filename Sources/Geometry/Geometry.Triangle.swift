// Triangle.swift
// A triangle defined by three vertices.

extension Geometry {
    /// A triangle in 2D space defined by three vertices.
    ///
    /// Vertices are ordered counter-clockwise for a positive signed area.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let triangle = Geometry<Double>.Triangle(
    ///     a: .init(x: 0, y: 0),
    ///     b: .init(x: 4, y: 0),
    ///     c: .init(x: 2, y: 3)
    /// )
    /// print(triangle.area)      // 6.0
    /// print(triangle.centroid)  // (2, 1)
    /// ```
    public struct Triangle {
        /// First vertex
        public var a: Point<2>

        /// Second vertex
        public var b: Point<2>

        /// Third vertex
        public var c: Point<2>

        /// Create a triangle with three vertices
        @inlinable
        public init(a: consuming Point<2>, b: consuming Point<2>, c: consuming Point<2>) {
            self.a = a
            self.b = b
            self.c = c
        }
    }
}

extension Geometry.Triangle: Sendable where Scalar: Sendable {}
extension Geometry.Triangle: Equatable where Scalar: Equatable {}
extension Geometry.Triangle: Hashable where Scalar: Hashable {}

// MARK: - Codable

extension Geometry.Triangle: Codable where Scalar: Codable {}

// MARK: - Vertices and Edges

extension Geometry.Triangle {
    /// The three vertices as an array
    @inlinable
    public var vertices: [Geometry.Point<2>] {
        [a, b, c]
    }
}

extension Geometry.Triangle where Scalar: AdditiveArithmetic {
    /// The three edges as line segments
    @inlinable
    public var edges: (ab: Geometry.Line.Segment, bc: Geometry.Line.Segment, ca: Geometry.Line.Segment) {
        (
            Geometry.Line.Segment(start: a, end: b),
            Geometry.Line.Segment(start: b, end: c),
            Geometry.Line.Segment(start: c, end: a)
        )
    }
}

// MARK: - Area and Perimeter (SignedNumeric)

extension Geometry.Triangle where Scalar: SignedNumeric {
    /// The signed double area of the triangle.
    ///
    /// Positive if vertices are counter-clockwise, negative if clockwise.
    /// Uses the shoelace formula: x_a(y_b - y_c) + x_b(y_c - y_a) + x_c(y_a - y_b)
    @inlinable
    public var signedDoubleArea: Scalar {
        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        return ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)
    }
}

extension Geometry.Triangle where Scalar: FloatingPoint {
    /// The signed area of the triangle
    @inlinable
    public var signedArea: Scalar {
        let two: Scalar = Scalar(2)
        return signedDoubleArea / two
    }

    /// The area of the triangle (always positive)
    @inlinable
    public var area: Scalar {
        let two: Scalar = Scalar(2)
        return abs(signedDoubleArea) / two
    }

    /// The perimeter of the triangle
    @inlinable
    public var perimeter: Scalar {
        let ab: Scalar = a.distance(to: b)
        let bc: Scalar = b.distance(to: c)
        let ca: Scalar = c.distance(to: a)
        return ab + bc + ca
    }

    /// The lengths of the three sides [|AB|, |BC|, |CA|]
    @inlinable
    public var sideLengths: (ab: Scalar, bc: Scalar, ca: Scalar) {
        let ab: Scalar = a.distance(to: b)
        let bc: Scalar = b.distance(to: c)
        let ca: Scalar = c.distance(to: a)
        return (ab, bc, ca)
    }
}

// MARK: - Centroid and Centers (FloatingPoint)

extension Geometry.Triangle where Scalar: FloatingPoint {
    /// The centroid (center of mass) of the triangle.
    ///
    /// The centroid is the intersection of the medians.
    @inlinable
    public var centroid: Geometry.Point<2> {
        let three: Scalar = Scalar(3)
        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        return Geometry.Point(
            x: Geometry.X((ax + bx + cx) / three),
            y: Geometry.Y((ay + by + cy) / three)
        )
    }

    /// The incircle (largest inscribed circle) of the triangle.
    ///
    /// The incircle's center is equidistant from all three sides.
    /// Returns `nil` if the triangle is degenerate.
    @inlinable
    public var incircle: Geometry.Circle? {
        let sides = sideLengths
        let ab: Scalar = sides.ab
        let bc: Scalar = sides.bc
        let ca: Scalar = sides.ca
        let two: Scalar = Scalar(2)
        let s: Scalar = (ab + bc + ca) / two  // semi-perimeter
        guard s > Scalar(0) else { return nil }

        // Incenter coordinates (weighted by opposite side lengths)
        let totalWeight: Scalar = ab + bc + ca
        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        let ix: Scalar = (bc * ax + ca * bx + ab * cx) / totalWeight
        let iy: Scalar = (bc * ay + ca * by + ab * cy) / totalWeight

        // Inradius = Area / semi-perimeter
        let r: Scalar = area / s

        return Geometry.Circle(
            center: Geometry.Point(x: Geometry.X(ix), y: Geometry.Y(iy)),
            radius: Geometry.Length(r)
        )
    }

    /// The circumcircle (smallest enclosing circle passing through all vertices).
    ///
    /// Returns `nil` if the triangle is degenerate (collinear vertices).
    @inlinable
    public var circumcircle: Geometry.Circle? {
        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        let two: Scalar = Scalar(2)

        let d: Scalar = two * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
        guard abs(d) > Scalar.ulpOfOne else { return nil }

        let aSq: Scalar = ax * ax + ay * ay
        let bSq: Scalar = bx * bx + by * by
        let cSq: Scalar = cx * cx + cy * cy

        let ux: Scalar = (aSq * (by - cy) + bSq * (cy - ay) + cSq * (ay - by)) / d
        let uy: Scalar = (aSq * (cx - bx) + bSq * (ax - cx) + cSq * (bx - ax)) / d

        let center: Geometry.Point<2> = Geometry.Point(x: Geometry.X(ux), y: Geometry.Y(uy))
        let radius: Scalar = center.distance(to: a)

        return Geometry.Circle(center: center, radius: Geometry.Length(radius))
    }

    /// The orthocenter (intersection of altitudes).
    ///
    /// Returns `nil` if the triangle is degenerate.
    @inlinable
    public var orthocenter: Geometry.Point<2>? {
        guard let cc = circumcircle else { return nil }
        let two: Scalar = Scalar(2)

        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        let ccx: Scalar = cc.center.x.value
        let ccy: Scalar = cc.center.y.value

        let ox: Scalar = ax + bx + cx - two * ccx
        let oy: Scalar = ay + by + cy - two * ccy

        return Geometry.Point(x: Geometry.X(ox), y: Geometry.Y(oy))
    }
}

// MARK: - Angles (BinaryFloatingPoint)

extension Geometry.Triangle where Scalar: BinaryFloatingPoint {
    /// The interior angles at each vertex [angle at A, angle at B, angle at C].
    ///
    /// Angles are in radians and always sum to π.
    @inlinable
    public var angles: (atA: Radian, atB: Radian, atC: Radian) {
        let sides = sideLengths
        let ab: Scalar = sides.ab
        let bc: Scalar = sides.bc
        let ca: Scalar = sides.ca
        let two: Scalar = Scalar(2)

        // Law of cosines: cos(A) = (b² + c² - a²) / (2bc)
        let cosA: Scalar = (ca * ca + ab * ab - bc * bc) / (two * ca * ab)
        let cosB: Scalar = (ab * ab + bc * bc - ca * ca) / (two * ab * bc)
        let cosC: Scalar = (bc * bc + ca * ca - ab * ab) / (two * bc * ca)

        return (
            Radian.acos(Double(cosA)),
            Radian.acos(Double(cosB)),
            Radian.acos(Double(cosC))
        )
    }
}

// MARK: - Containment (FloatingPoint)

extension Geometry.Triangle where Scalar: FloatingPoint {
    /// Check if a point is inside or on the triangle.
    ///
    /// Uses barycentric coordinates for robust containment testing.
    ///
    /// - Parameter point: The point to test
    /// - Returns: `true` if the point is inside or on the boundary
    @inlinable
    public func contains(_ point: Geometry.Point<2>) -> Bool {
        guard let bary = barycentric(point) else { return false }
        let zero: Scalar = Scalar(0)
        return bary.u >= zero && bary.v >= zero && bary.w >= zero
    }

    /// Compute the barycentric coordinates of a point with respect to this triangle.
    ///
    /// For a point inside the triangle, all coordinates are in [0, 1] and sum to 1.
    ///
    /// - Parameter point: The point to compute coordinates for
    /// - Returns: The barycentric coordinates (u, v, w) where P = u*A + v*B + w*C, or nil if degenerate
    @inlinable
    public func barycentric(_ point: Geometry.Point<2>) -> (u: Scalar, v: Scalar, w: Scalar)? {
        let v0: Geometry.Vector<2> = Geometry.Vector(dx: c.x - a.x, dy: c.y - a.y)
        let v1: Geometry.Vector<2> = Geometry.Vector(dx: b.x - a.x, dy: b.y - a.y)
        let v2: Geometry.Vector<2> = Geometry.Vector(dx: point.x - a.x, dy: point.y - a.y)

        let dot00: Scalar = v0.dot(v0)
        let dot01: Scalar = v0.dot(v1)
        let dot02: Scalar = v0.dot(v2)
        let dot11: Scalar = v1.dot(v1)
        let dot12: Scalar = v1.dot(v2)

        let denom: Scalar = dot00 * dot11 - dot01 * dot01
        guard abs(denom) > Scalar.ulpOfOne else { return nil }

        let one: Scalar = Scalar(1)
        let invDenom: Scalar = one / denom
        let v: Scalar = (dot11 * dot02 - dot01 * dot12) * invDenom
        let u: Scalar = (dot00 * dot12 - dot01 * dot02) * invDenom
        let w: Scalar = one - u - v

        return (w, u, v)
    }

    /// Convert barycentric coordinates to a Cartesian point.
    ///
    /// - Parameters:
    ///   - u: Weight for vertex A
    ///   - v: Weight for vertex B
    ///   - w: Weight for vertex C
    /// - Returns: The Cartesian point
    @inlinable
    public func point(u: Scalar, v: Scalar, w: Scalar) -> Geometry.Point<2> {
        let ax: Scalar = a.x.value
        let ay: Scalar = a.y.value
        let bx: Scalar = b.x.value
        let by: Scalar = b.y.value
        let cx: Scalar = c.x.value
        let cy: Scalar = c.y.value
        return Geometry.Point(
            x: Geometry.X(u * ax + v * bx + w * cx),
            y: Geometry.Y(u * ay + v * by + w * cy)
        )
    }
}

// MARK: - Bounding Box (Comparable)

extension Geometry.Triangle where Scalar: Comparable {
    /// The axis-aligned bounding box of the triangle
    @inlinable
    public var boundingBox: Geometry.Rectangle {
        let minX: Geometry.X = min(a.x, min(b.x, c.x))
        let maxX: Geometry.X = max(a.x, max(b.x, c.x))
        let minY: Geometry.Y = min(a.y, min(b.y, c.y))
        let maxY: Geometry.Y = max(a.y, max(b.y, c.y))
        return Geometry.Rectangle(llx: minX, lly: minY, urx: maxX, ury: maxY)
    }
}

// MARK: - Transformation (FloatingPoint)

extension Geometry.Triangle where Scalar: FloatingPoint {
    /// Return a triangle translated by the given vector.
    @inlinable
    public func translated(by vector: Geometry.Vector<2>) -> Self {
        Self(a: a + vector, b: b + vector, c: c + vector)
    }

    /// Return a triangle scaled uniformly about its centroid.
    @inlinable
    public func scaled(by factor: Scalar) -> Self {
        let center: Geometry.Point<2> = centroid
        return scaled(by: factor, about: center)
    }

    /// Return a triangle scaled uniformly about a given point.
    @inlinable
    public func scaled(by factor: Scalar, about point: Geometry.Point<2>) -> Self {
        let px: Scalar = point.x.value
        let py: Scalar = point.y.value

        func scalePoint(_ p: Geometry.Point<2>) -> Geometry.Point<2> {
            let x: Scalar = px + factor * (p.x.value - px)
            let y: Scalar = py + factor * (p.y.value - py)
            return Geometry.Point(x: Geometry.X(x), y: Geometry.Y(y))
        }
        return Self(a: scalePoint(a), b: scalePoint(b), c: scalePoint(c))
    }
}

// MARK: - Functorial Map

extension Geometry.Triangle {
    /// Create a triangle by transforming the coordinates of another triangle
    @inlinable
    public init<U>(_ other: borrowing Geometry<U>.Triangle, _ transform: (U) -> Scalar) {
        self.init(
            a: Geometry.Point<2>(other.a, transform),
            b: Geometry.Point<2>(other.b, transform),
            c: Geometry.Point<2>(other.c, transform)
        )
    }

    /// Transform coordinates using the given closure
    @inlinable
    public func map<Result>(
        _ transform: (Scalar) -> Result
    ) -> Geometry<Result>.Triangle {
        Geometry<Result>.Triangle(
            a: a.map(transform),
            b: b.map(transform),
            c: c.map(transform)
        )
    }
}
