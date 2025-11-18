# Category Theory Properties of Time Module

This document describes the mathematical and categorical properties of the Time module from an academic perspective.

## Type Classifications

### 1. Time.Weekday (Time.Week.Day)

**Categorical Structure**: Free coproduct (sum type)

```
Weekday ≅ 1 + 1 + 1 + 1 + 1 + 1 + 1
```

Seven disjoint unit types: `sunday | monday | tuesday | wednesday | thursday | friday | saturday`

**Properties**:
- **Enumerable**: `CaseIterable` provides `allCases: [Weekday]`
- **Equality**: Decidable equality (syntactic)
- **Ordering**: No canonical ordering (intentionally - ordering depends on convention)

**Interpretation Morphisms**:
- `isoNumber: Weekday → ℕ₇` (where ℕ₇ = {1,2,3,4,5,6,7})
- `gregorianNumber: Weekday → ℕ₆` (where ℕ₆ = {0,1,2,3,4,5,6})

These are **bijections** (one-to-one correspondences):
```
isoNumber: monday ↦ 1, tuesday ↦ 2, ..., sunday ↦ 7
gregorianNumber: sunday ↦ 0, monday ↦ 1, ..., saturday ↦ 6
```

**Inverse Morphisms**:
- `init?(isoNumber:): ℕ → Weekday?` (partial - only defined on 1-7)
- `init?(gregorianNumber:): ℕ → Weekday?` (partial - only defined on 0-6)

### 2. DateComponents

**Categorical Structure**: Refinement type (subobject)

```
DateComponents ⊂ ℤ × ℤ × ℤ × ℤ × ℤ × ℤ
                (year, month, day, hour, minute, second)
```

Not all tuples are valid - constrained by:
- `1 ≤ month ≤ 12`
- `1 ≤ day ≤ daysInMonth(year, month)`
- `0 ≤ hour ≤ 23`
- `0 ≤ minute ≤ 59`
- `0 ≤ second ≤ 60` (allowing leap second)

**Constructor**: Partial function with error
```
init: (ℤ × ℤ × ℤ × ℤ × ℤ × ℤ) ⇀ DateComponents
```

**Invariant**: All publicly constructible `DateComponents` instances satisfy the constraints above.

**Internal unsafe constructor** (for performance when values are known valid):
```
init(unchecked:): (ℤ × ℤ × ℤ × ℤ × ℤ × ℤ) → DateComponents
```
⚠️ Must only be used when preconditions are proven (e.g., values from epoch conversion).

### 3. EpochConversion

**Categorical Structure**: Bijection (isomorphism) between representations

```
components: ℤ → (ℤ × ℤ × ℤ × ℤ × ℤ × ℤ)
secondsSinceEpoch: (ℤ × ℤ × ℤ × ℤ × ℤ × ℤ) → ℤ
```

**Round-trip Property** (must hold):
```
∀ valid (y,m,d,h,min,s):
  components(secondsSinceEpoch(y,m,d,h,min,s)) = (y,m,d,h,min,s)

∀ n ∈ ℤ:
  secondsSinceEpoch(components(n)) = n
```

These form an **isomorphism** between:
- Unix epoch seconds (ℤ)
- Valid date-time tuples (subset of ℤ⁶)

**Note**: This is not a perfect isomorphism due to:
- Leap seconds (60th second)
- Historical calendar discontinuities
- But it's close enough for practical purposes

### 4. GregorianCalendar

**Categorical Structure**: Module of pure functions (morphisms)

```
isLeapYear: ℤ → Bool
daysInMonth: ℤ × ℤ → ℤ
```

**Properties**:
- **Deterministic**: Same inputs always produce same outputs
- **Pure**: No side effects
- **Total**: Defined for all integer inputs (though only meaningful for reasonable years)

**Mathematical Definition**:
```
isLeapYear(y) = (y ≡ 0 (mod 4) ∧ y ≢ 0 (mod 100)) ∨ (y ≡ 0 (mod 400))
```

This encodes the Gregorian calendar rule:
- Divisible by 4: leap year
- EXCEPT divisible by 100: not leap year
- EXCEPT divisible by 400: leap year

## Functorial Properties

### Weekday Calculation as Natural Transformation

The weekday calculation:
```
weekday: ValidDate → Weekday
```

Is a **natural transformation** from the category of valid Gregorian dates to the discrete category of weekdays.

**Equivariance Property**: The weekday respects date arithmetic
```
weekday(date + 7 days) = weekday(date)
weekday(date + 1 day) = next(weekday(date))
```

Where `next: Weekday → Weekday` is the successor function (modulo 7).

### Epoch Conversion as Adjunction

The epoch conversion forms an **adjunction** between:
- **Left**: DateComponents (structured representation)
- **Right**: Int (linear representation)

With natural transformations:
- `η: DateComponents → Int` (secondsSinceEpoch)
- `ε: Int → DateComponents` (components)

Satisfying:
- `ε ∘ η = id` (round-trip from components)
- `η ∘ ε = id` (round-trip from epoch)

## Algebraic Properties

### Weekday as Cyclic Group

The weekdays form a **cyclic group** ℤ/7ℤ under "days from now":

```
next: Weekday → Weekday
next(saturday) = sunday
next(w) = successor(w)
```

**Group properties**:
- **Identity**: `repeat 7 times next = id`
- **Associativity**: Day arithmetic is associative
- **Inverse**: `prev` is the inverse of `next`

This makes weekdays isomorphic to ℤ₇ (integers mod 7).

### DateComponents as Dependent Product

Categorically, `DateComponents` is a **dependent product type**:

```
DateComponents = Σ (year: ℤ)
                   (month: Fin 12)
                   (day: Fin (daysInMonth year month))
                   (hour: Fin 24)
                   (minute: Fin 60)
                   (second: Fin 61)
```

Where `Fin n` is the type of natural numbers less than `n`.

The `day` field **depends** on `year` and `month` - its valid range is determined by them.

## Design Principles

### 1. Type Safety via Refinement Types

```swift
// ✓ Good: Can only construct valid DateComponents
let valid = try DateComponents(year: 2024, month: 2, day: 29)

// ✓ Good: Rejects invalid dates
try DateComponents(year: 2023, month: 2, day: 29)  // throws
```

**Invariant**: All public `DateComponents` instances are valid.

### 2. Convention-Independent Representation

```swift
// The weekday IS monday - this is absolute
let weekday = try Time.Weekday(year: 2024, month: 1, day: 15)

// Conventions only affect NUMBERING
weekday.isoNumber        // 1 (interpretation)
weekday.gregorianNumber  // 1 (different interpretation)
```

**Principle**: Separate **data** (what day it is) from **interpretation** (how we number it).

### 3. Totality Where Possible

```swift
// ✓ Total functions (always succeed)
GregorianCalendar.isLeapYear(2024)
weekday.isoNumber

// ⚠️ Partial functions (may fail) - use throws or Optional
Time.Weekday(year:month:day:)  // throws
Time.Weekday(isoNumber:)       // Optional
```

**Principle**: Make illegal states unrepresentable. Use types to enforce constraints.

## Testing Requirements

To verify these categorical properties, tests should verify:

### Round-trip Properties
```swift
// Epoch conversion isomorphism
∀ valid date: components(secondsSinceEpoch(date)) == date
∀ epoch: secondsSinceEpoch(components(epoch)) == epoch

// Weekday number conversions
∀ weekday: Weekday(isoNumber: weekday.isoNumber) == weekday
∀ weekday: Weekday(gregorianNumber: weekday.gregorianNumber) == weekday
```

### Equivariance Properties
```swift
// Weekday calculation respects date arithmetic
weekday(date) == weekday(date + 7 days)
```

### Edge Cases
```swift
// Leap years (divisible by 400)
isLeapYear(2000) == true
isLeapYear(2400) == true

// Not leap years (divisible by 100 but not 400)
isLeapYear(2100) == false
isLeapYear(1900) == false

// Leap second
try DateComponents(second: 60)  // Should succeed
```

## Future Extensions

### Calendar as Type Class (Protocol)

For supporting multiple calendar systems:

```swift
protocol Calendar {
    func isLeapYear(_ year: Int) -> Bool
    func daysInMonth(year: Int, month: Int) -> Int
    // ...
}

struct GregorianCalendar: Calendar { ... }
struct JulianCalendar: Calendar { ... }
struct IslamicCalendar: Calendar { ... }
```

Then `DateComponents` could be parameterized:
```swift
struct DateComponents<Cal: Calendar> {
    let calendar: Cal
    // ...
}
```

### Week as First-Class Type

```swift
extension Time {
    /// Represents a calendar week (year + week number)
    struct Week {
        let year: Int
        let weekNumber: Int  // 1-53 (ISO 8601)

        enum Day { ... }  // Already have this
    }
}
```

This would make the `Time.Week` namespace meaningful.

## References

- Gregorian calendar: 400-year cycle with 146097 days
- ISO 8601: Monday=1, weeks start on Monday
- RFC 5322: Sunday=0, traditional Western numbering
- Category Theory: Refinement types, adjunctions, natural transformations
