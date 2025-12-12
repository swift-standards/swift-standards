// Corner.swift
// Layout-aware rectangle corners.

public import Dimension
public import Region

/// A layout-relative corner of a rectangle that adapts to text direction.
///
/// Represents corners using leading/trailing terminology that automatically
/// adapts to left-to-right or right-to-left layouts. Use this for UI elements
/// that should mirror in RTL locales (Arabic, Hebrew, etc.).
///
/// ## Example
///
/// ```swift
/// // Define a notification badge position
/// let badge = Corner.topTrailing  // Top-right in LTR, top-left in RTL
///
/// // Convert to absolute coordinates
/// let absolute = Region.Corner(badge, direction: .leftToRight)  // .topRight
/// let rtl = Region.Corner(badge, direction: .rightToLeft)       // .topLeft
/// ```
public struct Corner: Sendable, Hashable, Codable {
    /// Horizontal side (leading or trailing)
    public var horizontal: Horizontal.Alignment.Side

    /// Vertical side (top or bottom)
    public var vertical: Vertical.Alignment.Side

    /// Creates a corner from horizontal and vertical sides.
    @inlinable
    public init(horizontal: Horizontal.Alignment.Side, vertical: Vertical.Alignment.Side) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

// MARK: - Horizontal Side

extension Horizontal.Alignment {
    /// A horizontal edge of a rectangle (leading or trailing).
    ///
    /// Excludes center, representing only the two horizontal edges.
    public enum Side: Sendable, Hashable, Codable, CaseIterable {
        /// Leading edge (left in LTR, right in RTL)
        case leading
        /// Trailing edge (right in LTR, left in RTL)
        case trailing

        /// Returns the opposite side.
        @inlinable
        public static func opposite(_ side: Side) -> Side {
            switch side {
            case .leading: return .trailing
            case .trailing: return .leading
            }
        }

        /// Returns the opposite side.
        @inlinable
        public var opposite: Side {
            Self.opposite(self)
        }
    }
}

// MARK: - Horizontal from Side

extension Horizontal {
    /// Creates an absolute horizontal direction from a layout-relative side.
    @inlinable
    public init(_ side: Horizontal.Alignment.Side, direction: Direction) {
        switch (side, direction) {
        case (.leading, .leftToRight), (.trailing, .rightToLeft):
            self = .leftward
        case (.trailing, .leftToRight), (.leading, .rightToLeft):
            self = .rightward
        }
    }
}

// MARK: - Vertical Side

extension Vertical.Alignment {
    /// A vertical edge of a rectangle (top or bottom).
    ///
    /// Excludes center, representing only the two vertical edges.
    public enum Side: Sendable, Hashable, Codable, CaseIterable {
        /// Top edge
        case top
        /// Bottom edge
        case bottom

        /// Returns the opposite side.
        @inlinable
        public static func opposite(_ side: Side) -> Side {
            switch side {
            case .top: return .bottom
            case .bottom: return .top
            }
        }

        /// Returns the opposite side.
        @inlinable
        public var opposite: Side {
            Self.opposite(self)
        }
    }
}

// MARK: - Vertical from Side

extension Vertical {
    /// Creates a vertical direction from a vertical side.
    @inlinable
    public init(_ side: Vertical.Alignment.Side) {
        switch side {
        case .top: self = .upward
        case .bottom: self = .downward
        }
    }
}

// MARK: - Named Corners

extension Corner {
    /// Top-leading corner (top-left in LTR, top-right in RTL)
    public static let topLeading = Corner(horizontal: .leading, vertical: .top)

    /// Top-trailing corner (top-right in LTR, top-left in RTL)
    public static let topTrailing = Corner(horizontal: .trailing, vertical: .top)

    /// Bottom-leading corner (bottom-left in LTR, bottom-right in RTL)
    public static let bottomLeading = Corner(horizontal: .leading, vertical: .bottom)

    /// Bottom-trailing corner (bottom-right in LTR, bottom-left in RTL)
    public static let bottomTrailing = Corner(horizontal: .trailing, vertical: .bottom)
}

// MARK: - CaseIterable

extension Corner: CaseIterable {
    public static let allCases: [Corner] = [
        .topLeading, .topTrailing, .bottomLeading, .bottomTrailing,
    ]
}

// MARK: - Opposite

extension Corner {
    /// Returns the diagonally opposite corner.
    @inlinable
    public static func opposite(_ corner: Corner) -> Corner {
        Corner(horizontal: .opposite(corner.horizontal), vertical: .opposite(corner.vertical))
    }

    /// Diagonally opposite corner
    @inlinable
    public var opposite: Corner {
        Self.opposite(self)
    }

    /// Returns the diagonally opposite corner.
    @inlinable
    public static prefix func ! (value: Corner) -> Corner {
        value.opposite
    }
}

// MARK: - Properties

extension Corner {
    /// Whether this corner is on the top edge
    @inlinable
    public static func isTop(_ corner: Corner) -> Bool {
        corner.vertical == .top
    }

    /// Whether this corner is on the top edge
    @inlinable
    public var isTop: Bool { Self.isTop(self) }

    /// Whether this corner is on the bottom edge
    @inlinable
    public static func isBottom(_ corner: Corner) -> Bool {
        corner.vertical == .bottom
    }

    /// Whether this corner is on the bottom edge
    @inlinable
    public var isBottom: Bool { Self.isBottom(self) }

    /// Whether this corner is on the leading edge
    @inlinable
    public static func isLeading(_ corner: Corner) -> Bool {
        corner.horizontal == .leading
    }

    /// Whether this corner is on the leading edge
    @inlinable
    public var isLeading: Bool { Self.isLeading(self) }

    /// Whether this corner is on the trailing edge
    @inlinable
    public static func isTrailing(_ corner: Corner) -> Bool {
        corner.horizontal == .trailing
    }

    /// Whether this corner is on the trailing edge
    @inlinable
    public var isTrailing: Bool { Self.isTrailing(self) }
}

// MARK: - Adjacent Corners

extension Corner {
    /// Returns the corner horizontally adjacent along the same edge.
    @inlinable
    public static func horizontalAdjacent(_ corner: Corner) -> Corner {
        Corner(horizontal: .opposite(corner.horizontal), vertical: corner.vertical)
    }

    /// Corner horizontally adjacent along the same edge
    @inlinable
    public var horizontalAdjacent: Corner {
        Self.horizontalAdjacent(self)
    }

    /// Returns the corner vertically adjacent along the same edge.
    @inlinable
    public static func verticalAdjacent(_ corner: Corner) -> Corner {
        Corner(horizontal: corner.horizontal, vertical: .opposite(corner.vertical))
    }

    /// Corner vertically adjacent along the same edge
    @inlinable
    public var verticalAdjacent: Corner {
        Self.verticalAdjacent(self)
    }
}

// MARK: - Region.Corner from Layout.Corner

extension Region.Corner {
    /// Creates an absolute corner from a layout-relative corner.
    @inlinable
    public init(_ corner: Corner, direction: Direction) {
        self.init(
            horizontal: Horizontal(corner.horizontal, direction: direction),
            vertical: Vertical(corner.vertical)
        )
    }
}
