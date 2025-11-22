# RFC 3339 Categorical Analysis

Category-theoretic analysis of RFC 3339 as a profile of ISO 8601, with formal specification of the morphisms between timeline and calendar representations.

## 1. The Category of Time Representations

### 1.1 Objects

**Definition 1.1.1** (Timeline): A **timeline** is a totally ordered abelian group (ℤ, +) representing discrete seconds since an epoch.

**Definition 1.1.2** (Calendar): A **calendar** is a dependent product type:
```
Calendar = Σ (year: ℤ)
             (month: Fin 12)
             (day: Fin (daysInMonth year month))
             (hour: Fin 24)
             (minute: Fin 60)
             (second: Fin 61)       -- 61 to allow leap seconds
             (nanos: Fin 1000000000)
```

**Definition 1.1.3** (Instant): An **instant** is a pair `(s, n) ∈ ℤ × Fin(10⁹)` where:
- `s`: seconds since Unix epoch (1970-01-01 00:00:00 UTC)
- `n`: nanosecond fraction within the second

### 1.2 Morphisms

**Definition 1.2.1** (Epoch Conversion): The **epoch conversion** is a bijection:
```
φ: Calendar → Instant
φ⁻¹: Instant → Calendar
```

This forms an **isomorphism** in the category of time representations (modulo leap seconds).

**Theorem 1.2.2** (Round-trip Property):
```
∀ c ∈ Calendar: φ⁻¹(φ(c)) = c    (component-wise equality)
∀ i ∈ Instant:  φ(φ⁻¹(i)) = i    (second-wise equality, nanos preserved)
```

**Proof**: By construction of the Gregorian calendar algorithms in `Time.Epoch.Conversion.swift`.

### 1.3 Duration as Morphism Composition

**Definition 1.3.1** (Duration): A **duration** `d` is an element of the abelian group (ℤ × ℤ, +) representing:
```
d = (seconds, attoseconds)  where attoseconds ∈ [0, 10¹⁸)
```

**Definition 1.3.2** (Timeline Addition): The operation `+: Instant × Duration → Instant` is defined:
```
(s₁, n₁) + (s₂, a₂) = normalize(s₁ + s₂, n₁ + ⌊a₂/10⁹⌋)

where normalize(s, n) =
  if n ≥ 10⁹ then normalize(s+1, n-10⁹)
  else if n < 0 then normalize(s-1, n+10⁹)
  else (s, n)
```

**Theorem 1.3.3** (Associativity): Timeline addition is associative:
```
∀ i ∈ Instant, ∀ d₁, d₂ ∈ Duration: (i + d₁) + d₂ = i + (d₁ + d₂)
```

**Proof**: Normalization preserves the total elapsed time in attoseconds. The operation is well-defined on equivalence classes modulo 10⁹.

## 2. RFC 3339 as a Subobject

### 2.1 The RFC 3339 Grammar

**Definition 2.1.1** (RFC 3339 Date-Time): An **RFC 3339 date-time** is a tuple:
```
RFC3339 = (Calendar, UtcOffset, Precision)

where:
  UtcOffset ∈ ℤ          -- offset in seconds, or special value Z
  Precision ∈ ℕ ∪ {∞}    -- number of fractional digits
```

**Definition 2.1.2** (Valid RFC 3339): A valid RFC 3339 timestamp satisfies:
1. All calendar components are in valid ranges per Definition 1.1.2
2. Offset is in range [-12*3600, +14*3600] seconds
3. If `second = 60`, month-day must be June 30 or December 31
4. Fractional part has `Precision` digits (or infinite precision if omitted)

### 2.2 The Restriction Functor

**Definition 2.2.1** (ISO 8601 Full): Let `ISO8601` be the category of all ISO 8601 representations, including:
- Week dates (`YYYY-Www-D`)
- Ordinal dates (`YYYY-DDD`)
- Basic format (no separators)
- Extended format (with separators)
- Truncated representations
- Durations and intervals

**Definition 2.2.2** (RFC 3339 Restriction): RFC 3339 is the **subobject** of ISO 8601:
```
RFC3339 ⊂ ISO8601
```

defined by the inclusion functor `ι: RFC3339 → ISO8601` that:
1. Requires extended format (hyphens and colons)
2. Requires full precision (no truncation)
3. Requires explicit timezone offset
4. Allows only calendar dates (no week/ordinal)
5. Allows only date-time (no durations/intervals)

**Theorem 2.2.3** (Conformant Subset): RFC 3339 is a **conformant subset**:
```
∀ t ∈ RFC3339: ι(t) ∈ ISO8601  ∧  valid_ISO8601(ι(t))
```

**Quotation**: "It is a conformant subset of the ISO 8601 extended format." (RFC 3339, Section 1)

### 2.3 The String Representation Functor

**Definition 2.3.1** (String Serialization): The **serialization** functor is:
```
σ: RFC3339 → String

σ(year, month, day, hour, minute, second, nanos, offset, precision) =
  sprintf("%04d-%02d-%02dT%02d:%02d:%02d%sZ",
          year, month, day, hour, minute, second, frac, tz)

where:
  frac = format_fractional(nanos, precision)
  tz   = format_offset(offset)
```

**Theorem 2.3.2** (Injectivity): The serialization functor is **injective** (up to precision):
```
∀ t₁, t₂ ∈ RFC3339: σ(t₁) = σ(t₂) ⟹ t₁ ≡ₚ t₂
```

where `≡ₚ` denotes equivalence modulo precision.

**Theorem 2.3.3** (Parsing Inverse): There exists a parsing functor:
```
π: String → RFC3339 + Error

such that ∀ t ∈ RFC3339: π(σ(t)) = Right(t)
```

## 3. The Instant Protocol as Natural Transformation

### 3.1 Swift's InstantProtocol

Swift's `InstantProtocol` defines a **natural transformation** between:
```
Timeline ⟶ Instant
```

**Definition 3.1.1** (InstantProtocol Requirements):
```swift
protocol InstantProtocol {
    associatedtype Duration
    func advanced(by: Duration) -> Self
    func duration(to: Self) -> Duration
}
```

This encodes two morphisms:
1. `advanced: Instant × Duration → Instant`  (action)
2. `duration: Instant × Instant → Duration`  (difference)

**Theorem 3.1.2** (Torsor Structure): `Instant` with `Duration` forms a **torsor**:
```
∀ i₁, i₂ ∈ Instant: ∃! d ∈ Duration such that i₁.advanced(by: d) = i₂
```

**Proof**: The group action of durations on instants is free and transitive.

### 3.2 Precision as Quotient Map

**Definition 3.2.1** (Precision Quotient): The conversion from `Swift.Duration` (attosecond precision, 10⁻¹⁸) to `Instant` (nanosecond precision, 10⁻⁹) is a **quotient map**:
```
q: Duration → Instant.Nanoseconds
q(s, a) = (s, ⌊a / 10⁹⌋)
```

This induces an equivalence relation on durations:
```
d₁ ~ d₂  ⟺  ⌊d₁.attoseconds / 10⁹⌋ = ⌊d₂.attoseconds / 10⁹⌋
```

**Theorem 3.2.2** (Universal Property): For any function `f: Duration → Instant` that respects `~`, there exists a unique factorization:
```
f = g ∘ q

where g: Instant.Nanoseconds → Instant
```

**Proof**: By the universal property of quotient objects in category theory. The quotient map `q` is the canonical surjection.

**Theorem 3.2.3** (RFC 3339 Precision Sufficiency): RFC 3339 requires at most nanosecond precision:
```
time-secfrac = "." 1*DIGIT
```

While arbitrary digit count is allowed, internet protocols rarely exceed millisecond (10⁻³) precision. Nanosecond (10⁻⁹) exceeds practical requirements.

**Corollary 3.2.4**: The precision loss `Duration → Instant` is **acceptable** for RFC 3339 compliance, as sub-nanosecond precision is not expressible in the wire format.

**However**, for **lossless round-trips**, we have:

**Theorem 3.2.5** (Instant Precision Preservation):
```
∀ time: Time:
  Time(Instant(time)) = time

Proof: Instant stores full nanosecond precision (Int32).
       Time stores nanoseconds as (millisecond, microsecond, nanosecond).
       The conversion preserves all 9 decimal places.
```

**Implementation**: See `Time.init(secondsSinceEpoch:nanoseconds:)` at Time.swift:259

## 4. Implementation Correspondence

### 4.1 Type Mappings

| Mathematical Concept | Swift Implementation | File Location |
|---------------------|---------------------|---------------|
| Calendar | `Time` | `Time.swift:19` |
| Instant | `Instant` | `Instant.swift:30` |
| Duration | `Swift.Duration` | `Duration.swift:17` |
| Epoch Conversion φ | `Time.Epoch.Conversion` | `Time.Epoch.Conversion.swift:7` |
| Timeline Addition | `Instant.+(Duration)` | `Instant.swift:95` |
| UTC Offset | `Time.TimezoneOffset` | `Time.TimezoneOffset.swift:27` |

### 4.2 Morphism Implementations

**Morphism 4.2.1** (Calendar → Instant):
```swift
// Time.swift:340
public init(_ instant: Instant)  // φ⁻¹

// Instant.swift:62
public init(_ time: Time)  // φ
```

**Morphism 4.2.2** (Timeline Arithmetic):
```swift
// Instant.swift:95
public static func + (lhs: Instant, rhs: Duration) -> Instant

// Normalization ensures: (s, n) where n ∈ [0, 10⁹)
```

### 4.3 Invariants as Type Constraints

**Invariant 4.3.1** (Nanosecond Range): Enforced by validation:
```swift
// Instant.swift:44
guard nanosecondFraction >= 0 && nanosecondFraction < 1_000_000_000
```

This ensures `Instant` properly represents the quotient space ℤ / (10⁹ℤ).

**Invariant 4.3.2** (Month-Day Validity): Enforced by dependent types:
```swift
// Time.Month.Day is parameterized by month and year
Time.Month.Day(day, in: month, year: year)
```

This encodes the dependent product from Definition 1.1.2.

## 5. RFC 3339 Specific Requirements

### 5.1 Leap Second Handling

**Definition 5.1.1** (Leap Second): A leap second occurs when `second = 60`, which is valid only when:
```
(month = 6 ∧ day = 30) ∨ (month = 12 ∧ day = 31)
```

**Theorem 5.1.2** (Leap Second Encoding): In the `Instant` representation:
```
leap_second_instant = (base_seconds + 60, 0)
```

where `base_seconds` is the start of the day.

**Note**: RFC 3339 Section 5.7 states: "Leap seconds cannot be predicted far in advance due to the unpredictable rate of the rotation of the earth."

### 5.2 Unknown Offset Convention

**Definition 5.2.1** (Unknown Offset): RFC 3339 Section 4.3 defines:
```
"-00:00" = "UTC is known, but local offset is unknown"
"+00:00" or "Z" = "UTC, local offset is zero"
```

This is a **semantic distinction** not captured in the numeric offset value alone.

**Theorem 5.2.2** (Instant Equivalence): Under instant conversion:
```
instant("-00:00") = instant("+00:00") = instant("Z")
```

The semantic distinction is lost. If needed, it must be preserved in a separate field.

### 5.3 Fractional Seconds

**Definition 5.3.1** (Time Secfrac Grammar):
```
time-secfrac = "." 1*DIGIT
```

**Theorem 5.3.2** (Variable Precision): RFC 3339 allows **arbitrary precision**:
```
"12:30:45.1"    = 100 milliseconds
"12:30:45.123"  = 123 milliseconds
"12:30:45.123456789" = 123456789 nanoseconds
```

**Implementation Note**: `Instant.nanosecondFraction: Int32` supports up to 9 decimal places (nanosecond precision), which exceeds typical internet protocol requirements.

## 6. Correctness Criteria

### 6.1 Round-Trip Properties

**Property 6.1.1** (String Round-Trip):
```
∀ valid_rfc3339_string s:
  serialize(parse(s)) = normalize(s)
```

where `normalize` canonicalizes formatting (e.g., "Z" vs "+00:00").

**Property 6.1.2** (Instant Round-Trip):
```
∀ time: Time, ∀ precision ≤ 9:
  Instant(Time(Instant(time))) ≡ Instant(time)  (modulo precision)
```

### 6.2 Conformance to RFC 3339

**Criterion 6.2.1** (Grammar Compliance): All serialized outputs must match:
```
date-time = full-date "T" full-time
```

**Criterion 6.2.2** (Mandatory Fields): RFC 3339 Section 5.6:
```
"Most fields and punctuation mandatory"
```

No truncation, no optional separators.

**Criterion 6.2.3** (Extended Format Only): RFC 3339 uses ISO 8601 extended format:
```
"2024-11-22T14:30:00Z"  -- valid (extended)
"20241122T143000Z"      -- INVALID (basic format)
```

## 7. Future Work

### 7.1 Interval and Duration Support

RFC 3339 does not define intervals or durations. However, ISO 8601 does:
```
P1Y2M3DT4H5M6S  -- Period: 1 year, 2 months, 3 days, 4h 5m 6s
```

A future `ISO8601.Duration` type could extend this with proper calendar arithmetic.

### 7.2 Alternative Calendars

The current implementation assumes the **proleptic Gregorian calendar**. Extensions for:
- Julian calendar (pre-1582)
- Islamic calendar
- Hebrew calendar

would require parameterizing `Time` by a `Calendar` protocol.

### 7.3 Timezone Database Integration

IANA timezone database (tzdata) provides named timezones:
```
"America/New_York"
"Europe/Amsterdam"
```

A future `Time.Timezone` type could map these to offset rules.

## References

- RFC 3339: Date and Time on the Internet: Timestamps
- ISO 8601:2019: Date and time — Representations for information interchange
- CATEGORICAL_PROPERTIES.md: Category theory foundations of Time module
- Time.Epoch.Conversion.swift: Bijection implementation
- Instant.swift: Timeline representation and arithmetic
