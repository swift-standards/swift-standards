// Predicate+(T) -> Bool.swift
// Convenience operators for raw (T) -> Bool closures.

// MARK: - (T) -> Bool Operators

/// Combines two boolean closures with logical AND.
///
/// ## Example
///
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isPositive: (Int) -> Bool = { $0 > 0 }
/// let predicate = isEven && isPositive
/// predicate(4)  // true
/// ```
@inlinable
public func && <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate(lhs).and(Predicate(rhs))
}

/// Combines two boolean closures with logical OR.
///
/// ## Example
///
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isNegative: (Int) -> Bool = { $0 < 0 }
/// let predicate = isEven || isNegative
/// predicate(-3)  // true
/// ```
@inlinable
public func || <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate(lhs).or(Predicate(rhs))
}

/// Combines two boolean closures with exclusive OR.
///
/// ## Example
///
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isPositive: (Int) -> Bool = { $0 > 0 }
/// let predicate = isEven ^ isPositive
/// predicate(3)  // true (only positive)
/// ```
@inlinable
public func ^ <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate(lhs).xor(Predicate(rhs))
}

/// Negates a boolean closure.
///
/// ## Example
///
/// ```swift
/// let isEven: (Int) -> Bool = { $0 % 2 == 0 }
/// let isOdd = !isEven
/// isOdd(3)  // true
/// ```
@inlinable
public prefix func ! <T>(
    closure: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate(closure).negated
}

// MARK: - Mixed Operators (Predicate with (T) -> Bool)

extension Predicate {
    /// Combines predicate with closure using logical AND.
    @inlinable
    public static func && (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        lhs.and(Predicate(rhs))
    }

    /// Combines closure with predicate using logical AND.
    @inlinable
    public static func && (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Predicate(lhs).and(rhs)
    }

    /// Combines predicate with closure using logical OR.
    @inlinable
    public static func || (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        lhs.or(Predicate(rhs))
    }

    /// Combines closure with predicate using logical OR.
    @inlinable
    public static func || (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Predicate(lhs).or(rhs)
    }

    /// Combines predicate with closure using exclusive OR.
    @inlinable
    public static func ^ (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        lhs.xor(Predicate(rhs))
    }

    /// Combines closure with predicate using exclusive OR.
    @inlinable
    public static func ^ (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Predicate(lhs).xor(rhs)
    }
}

// MARK: - Fluent Methods with (T) -> Bools

extension Predicate {
    /// Combines with closure using logical AND.
    @inlinable
    public func and(_ closure: @escaping (T) -> Bool) -> Predicate {
        and(Predicate(closure))
    }

    /// Combines with closure using logical OR.
    @inlinable
    public func or(_ closure: @escaping (T) -> Bool) -> Predicate {
        or(Predicate(closure))
    }

    /// Combines with closure using exclusive OR.
    @inlinable
    public func xor(_ closure: @escaping (T) -> Bool) -> Predicate {
        xor(Predicate(closure))
    }

    /// Combines with closure using NAND (not both).
    @inlinable
    public func nand(_ closure: @escaping (T) -> Bool) -> Predicate {
        nand(Predicate(closure))
    }

    /// Combines with closure using NOR (neither).
    @inlinable
    public func nor(_ closure: @escaping (T) -> Bool) -> Predicate {
        nor(Predicate(closure))
    }

    /// Creates implication with closure.
    @inlinable
    public func implies(_ closure: @escaping (T) -> Bool) -> Predicate {
        implies(Predicate(closure))
    }

    /// Creates biconditional with closure.
    @inlinable
    public func iff(_ closure: @escaping (T) -> Bool) -> Predicate {
        iff(Predicate(closure))
    }

    /// Creates reverse implication with closure.
    @inlinable
    public func unless(_ closure: @escaping (T) -> Bool) -> Predicate {
        unless(Predicate(closure))
    }
}
