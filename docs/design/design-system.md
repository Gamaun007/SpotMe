# Design System Inspired by The Verge — SwiftUI / iOS Implementation

> **Implementation target:** iOS 17+, SwiftUI, dark-locked.
> This document is the canonical reference for SpotMe's visual identity. All values here are **already converted to SwiftUI-native units** (points, `Color`, `Font`, `ButtonStyle`, `overlay`, size classes). Where the web original used `px`, `rem`, `hover`, `box-shadow`, or CSS breakpoints, those have been mapped to their iOS equivalents. The visual identity is preserved 1:1.

## 1. Visual Theme & Atmosphere

The Verge's 2024 redesign feels like somebody wired a Condé Nast magazine to a chiptune soundboard. The canvas is almost-black (`#131313`), the headlines are built from a brutally heavy display face (Manuka) that runs up to 107pt, and the whole page is peppered with acid-mint `#3cffd0` and ultraviolet `#5200ff` that behave less like brand colors and more like hazard tape. Story tiles are not quiet gray cards — they're saturated, full-bleed color blocks (yellow, pink, orange, blue, purple) that feel like pasted-up rave flyers arranged into a timeline. The mood is "developer console meets club night meets tech tabloid": serious enough to cover a congressional hearing, loud enough to review a synthesizer.

What makes this system unmistakable is the **StoryStream** timeline: a vertical feed where every post is a rounded rectangle — often 20–40pt radius — filled edge-to-edge with color, framed by a thin border, and marked by a mono-uppercase timestamp on its left rail. Stories don't float on a grid; they stack on a dashed vertical rule like commits in a git log. Above that, a massive **"The Verge" wordmark** dominates the masthead in Manuka at hero scale, letting the reader know before any headline loads that this is editorial territory, not a template.

There is no "light mode" on iOS — the dark canvas is the product. The app forces `.preferredColorScheme(.dark)` at the root level and ignores the system appearance. The only time the palette inverts is when a single story tile takes a mint or yellow fill. The depth is almost entirely flat: **hairline 1pt strokes** (`#ffffff`, `#3cffd0`, or `#5200ff`) applied via `.overlay(RoundedRectangle().stroke(...))` do the work that shadows would do on a Material-flavored site. Every container is either `#131313` with a 1pt outline, a fully saturated accent block, or a slate-gray `#2d2d2d` secondary surface.

**Key Characteristics:**
- Near-black editorial canvas (`#131313`) — locked dark, no system-light fallback
- Acid-mint `#3cffd0` + ultraviolet `#5200ff` as hazard-tape accents, never quiet background wash
- Massive Manuka display headlines up to 107pt — the loudest type move in the system
- Rounded pill-card everything: 20 / 24 / 30 / 40pt corner radii, never square
- Fully saturated color-block story tiles (mint, purple, yellow, pink, orange, electric blue) on the dark canvas
- Timeline "StoryStream" feed with mono uppercase timestamps rather than a traditional grid
- Flat depth — `.overlay()` borders in white, mint, and purple do the work that `.shadow()` would do elsewhere. **`.shadow()` is banned** outside the documented inset-underline use.

## 2. Color Palette & Roles

> **iOS pattern:** define each color once in `DesignSystem/Tokens/Colors.swift` as a `Color` extension (or in the Asset Catalog with locked Any/Dark = same value). Reference everywhere via `Color.spot…` — never inline hex.

### Primary (Brand Hazards)
- **Jelly Mint** (`#3cffd0` → `Color.spotMint`): CTA button fill, link underlines, active tab borders, and high-attention story-tile backgrounds. Treat it as the visual equivalent of neon safety paint — applied sparingly to the most important element on screen.
- **Verge Ultraviolet** (`#5200ff` → `Color.spotUltraviolet`): The complementary brand hazard. Secondary color-block tiles, promotional spans, occasional outlined buttons. Often applied at `.opacity(0.9)` to soften its cathode intensity.

### Secondary & Accent
- **Console Mint Border** (`#309875` → `Color.spotMintBorder`): A darker variant of jelly mint used on card outlines and button borders where pure mint would over-saturate.
- **Deep Link Blue** (`#3860be` → `Color.spotDeepLink`): The **press** color for links and headlines (replaces web hover — iOS has no hover state). Applied via `ButtonStyle` when `configuration.isPressed`.
- **Focus Cyan** (`#1eaedb` → `Color.spotFocus`): Reserved for `.focused()` rings on text fields and external-keyboard navigation. Never shown outside a focus state.
- **Purple Rule** (`#3d00bf` → `Color.spotPurpleRule`): The vertical rail color on StoryStream list items.

### Surface & Background
- **Canvas Black** (`#131313` → `Color.spotCanvas`): The default dark surface for every screen. Almost-but-not-quite pure black — has just enough warmth to feel like a printed newsprint negative rather than an OLED void.
- **Surface Slate** (`#2d2d2d` → `Color.spotSlate`): Secondary card background when a tile doesn't need to be a saturated color block. Also the resting fill of secondary buttons.
- **Image Frame** (`#313131` → `Color.spotImageFrame`): The 1pt stroke that wraps inline imagery.
- **Hazard White** (`#ffffff` → `Color.spotWhite`): Story-tile fill, button border, and primary text. When white appears as a large block, it's an editorial decision — a "spotlight" on that tile.
- **Absolute Black** (`#000000` → `Color.spotBlack`): Reserved for text on the mint/yellow/white tiles — the only place pure black appears.

### Neutrals & Text
- **Primary Text** (`#ffffff` → `Color.spotTextPrimary`): Headlines and display text on the canvas.
- **Secondary Text** (`#949494` → `Color.spotTextSecondary`): Bylines, timestamps, photo credits. The mid-gray that anchors the metadata layer.
- **Muted Text** (`#e9e9e9` → `Color.spotTextMuted`): Button text on dark slate buttons. Slightly off-white to reduce screen glare.
- **Inverted Text** (`#131313` → `Color.spotTextInverted`): Used only on accent tiles (mint, yellow, white) to keep contrast legible.

### Semantic & Press States
- **Focus Ring** (`#1eaedb` → `Color.spotFocus`): Keyboard focus only — typically rendered via `.focused()` + `.overlay`.
- **Card Ring Quiet** (`Color.black.opacity(0.33)`): Subtle 1pt overlay used as the quiet shadow alternative on stacked cards.
- **Dim Gray** (`#8c8c8c` → `Color.spotDim`): The pressed state background — the "pressed down" visual equivalent for primary buttons.

### Gradient System
**Zero decorative gradients.** SpotMe uses solid blocks only. The hazard-tape identity dissolves if anything fades. Do not reach for `LinearGradient` or `RadialGradient` anywhere in this codebase.

## 3. Typography Rules

> **iOS unit:** all sizes below are in **points (pt)**. The original web spec used `px` and `rem`; on iOS, 1pt is the canonical unit and we drop `rem` entirely. The visual proportions are identical.

### Font Family & iOS Substitutes

The Verge's fonts (Manuka, PolySans, FK Roman) are licensed faces unavailable on iOS by default. The system supports two paths:

| Role | Verge Font | Recommended iOS Substitute (bundle as `.ttf`/`.otf` in `Resources/Fonts/`, register in `Info.plist` `UIAppFonts`) | Free? |
|---|---|---|---|
| Display (hero) | Manuka 900 | **Anton Regular** — closest condensed-athletic stance; loosen `lineSpacing` slightly (see note) | ✅ Google Fonts |
| UI / Headlines | PolySans 300/500/700 | **Space Grotesk** 300/500/700 | ✅ Google Fonts |
| Mono labels | PolySans Mono | **Space Mono** Regular/Bold | ✅ Google Fonts |
| Editorial body | FK Roman Standard | **Newsreader** Regular | ✅ Google Fonts |

**Bundling:** drop `.ttf` files into `SpotMe/Resources/Fonts/`, then add a `UIAppFonts` array to `Info.plist` listing each filename. Reference via `Font.custom("Anton-Regular", size: 107)`.

If real Manuka / PolySans licenses are acquired later, swap the `font.custom("…")` calls — every Font usage flows through `Typography.swift`, so the swap is a single-file edit.

### Hierarchy

> **lineSpacing note:** SwiftUI's `.lineSpacing(_)` adds *extra* space between lines (it does not set absolute line-height). To approximate the web's tight `lineHeight: 0.80` on Manuka substitutes (Anton, Bebas Neue), use `.lineSpacing(-4)` to `-6` on large display sizes, or rely on `Text` defaults with no adjustment — for SpotMe we accept Anton's natural metrics and skip aggressive tightening.

| Role | Font | Size (pt) | Weight | `.tracking()` (pt) | Notes |
|---|---|---|---|---|---|
| Hero Wordmark / Display | Manuka (Anton) | 107 | 900 | 1.07 | Top-of-screen "SpotMe" wordmark and feature headlines |
| Secondary Display | Manuka (Anton) | 90 | 900 | — | Section-level feature headlines |
| Tertiary Display | Manuka (Anton) | 60 | 900 | — | Inline feature callouts |
| Large Headline | PolySans (Space Grotesk) | 34 | 700 | — | Section and module headlines |
| Heading Wide | PolySans (Space Grotesk) | 32 | 400 | 0.32 | Sub-heroes, promotional units |
| Heading Medium | PolySans (Space Grotesk) | 24 | 700 | — | Tile headlines |
| Heading Small | PolySans (Space Grotesk) | 20 | 700 | — | Compact tile headlines |
| Light Capitalized Label | PolySans (Space Grotesk) | 19 | 300 | 1.9 | Thin-weight capitalized eyebrows — signature whisper |
| All-Caps Label XL | PolySans (Space Grotesk) | 18 | 400 | 1.8 | UPPERCASE section kickers |
| Bold Body | PolySans (Space Grotesk) | 16 | 700 | — | Emphasis within decks |
| Body Relaxed | PolySans (Space Grotesk) | 16 | 500 | — | Long-form body |
| Inline Label | PolySans (Space Grotesk) | 15 | 400 | 0.15 | UI labels |
| Body Compact | PolySans (Space Grotesk) | 13 | 400 | — | Secondary captions |
| Eyebrow All-Caps | PolySans (Space Grotesk) | 12 | 400 | 1.8 | UPPERCASE kicker above headlines |
| Tag Label | PolySans (Space Grotesk) | 12 | 400 | 0.72 | UPPERCASE category tag |
| Caption Micro | PolySans (Space Grotesk) | 11 | 400 | 1.1 | UPPERCASE bylines |
| Meta Nano | PolySans (Space Grotesk) | 10 | 500 | 1.5 | UPPERCASE timestamp microtext |
| Mono Button Label | PolySans Mono (Space Mono) | 12 | 600 | 1.5 | UPPERCASE button text |
| Mono Timestamp | PolySans Mono (Space Mono) | 11 | 500/600 | 1.1–1.8 | UPPERCASE StoryStream timestamps |
| Serif Body | FK Roman (Newsreader) | 16 | 400 | −0.16 | Review decks |
| Serif Caption | FK Roman (Newsreader) | 20 | 400 | — | Pull quotes |

### SwiftUI Usage Pattern

```swift
extension Font {
    static let spotHero = Font.custom("Anton-Regular", size: 107)
    static let spotHeading = Font.custom("SpaceGrotesk-Bold", size: 24)
    static let spotMonoLabel = Font.custom("SpaceMono-Bold", size: 12)
    // …all roles centralized in Typography.swift
}

Text("LIVE NOW")
    .font(.spotMonoLabel)
    .tracking(1.5)
    .textCase(.uppercase)
    .foregroundStyle(Color.spotMint)
```

### Dynamic Type Policy

The Verge identity depends on precise type sizing — **opt out of Dynamic Type scaling for display roles** (Hero through Tertiary Display, all mono labels). For body roles (`Body Relaxed`, `Inline Label`, `Body Compact`), apply `.dynamicTypeSize(.medium ... .accessibility2)` to allow scaling within a bounded range. This is non-negotiable for trainee accessibility — trainees may use larger system text sizes.

### Principles
- **Manuka (Anton) is always the hero, never the UI.** If you see it below 60pt you're looking at a bug. It exists to shout the brand, not label a button.
- **PolySans (Space Grotesk) is the workhorse, PolySans Mono (Space Mono) is its uniformed sibling.** Mono is used exclusively for UPPERCASE labels, timestamps, tags, and certain buttons. Lowercase mono doesn't exist in this system — enforce via `.textCase(.uppercase)` on every mono `Text`.
- **Thin-weight (300) capitalized headlines** are a signature move. The 19–20pt weight-300 with 1.9pt tracking creates a "fashion magazine whisper" that contrasts with the 107pt Manuka shout above it. This whisper-vs-shout contrast is the typographic fingerprint.
- **`.tracking()` has two registers:** positive (0.72–1.9pt) for ALL-CAPS labels, negative (−0.16pt) for the rare serif appearances, barely-positive (0.32–1.07pt) for massive display. Plain 0 tracking is rare.
- **FK Roman (Newsreader) is the editorial exception**, not the rule. Reserve it for long-form moments — reviews, critic pulls. Never use in UI.
- **Tight, athletic display.** No artificial loosening on Anton or Bebas Neue substitutes. If using a wider-metric substitute, see the lineSpacing note above.

## 4. Component Stylings

> **iOS pattern for press / hover / active / focus:** SwiftUI has no `hover`. The web's hover state maps to **press** state on iOS, expressed via `ButtonStyle` and `configuration.isPressed`. `focus` maps to `.focused()` for keyboard / accessibility. There is no rest-vs-hover distinction — only rest, press, and focus.

### Buttons

All buttons live in `DesignSystem/Components/` as SwiftUI `ButtonStyle` conformances. Apply via `.buttonStyle(.spotPrimary)` etc.

**Primary — Jelly Mint Pill** (`SpotPrimaryButtonStyle`)
- Background: `Color.spotMint`
- Text: `Color.spotBlack`, `Font.spotMonoButton` (Space Mono 12pt / 600 UPPERCASE, `.tracking(1.5)`)
- Border radius: `24pt` — fully rounded pill (`Capsule()` or `RoundedRectangle(cornerRadius: 24)`)
- Padding: `EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24)`
- Min height: **56pt** (raised from web's 44pt minimum — SpotMe trainee UX requires larger primary targets)
- Press: background `Color.white.opacity(0.2)`, text stays black, 1pt `Color(.sRGB, white: 0.76, opacity: 1)` overlay ring
- Focus (keyboard): background `Color.spotFocus`, white text, 1pt `Color(red: 0.02, green: 0, blue: 1)` stroke
- Animation: `.animation(.easeOut(duration: 0.18), value: configuration.isPressed)`

**Secondary — Dark Slate Pill** (`SpotSecondaryButtonStyle`)
- Background: `Color.spotSlate`
- Text: `Color.spotTextMuted`, PolySans 16pt / 400
- Border: none
- Border radius: `24pt`
- Padding: `10×24pt`, min height 44pt
- Press: same translucent white invert as primary — `Color.white.opacity(0.2)` bg, black text, 1pt ring overlay
- Focus: same cyan focus treatment as primary

**Tertiary — Outlined Mint** (`SpotOutlinedMintButtonStyle`)
- Background: `Color.clear`
- Text: `Color.spotMint`, mono UPPERCASE 12pt / 600, `.tracking(1.5)`
- Border: `.overlay(Capsule().stroke(Color.spotMint, lineWidth: 1))`
- Border radius: `40pt` — larger pill for outline style
- Padding: ~`10×20pt`
- Press: inverts to `Color.spotMint` fill, `Color.spotBlack` text
- Animation: 150ms ease

**Outlined Ultraviolet (Promotional)** (`SpotOutlinedUltravioletButtonStyle`)
- Background: `Color.clear`
- Text: `Color.spotUltraviolet` or `Color.spotWhite`
- Border: 1pt `Color.spotUltraviolet` stroke
- Border radius: `30pt`
- Used for "Connect Trainer" / "Generate Code" style promotional callouts

**Pill Tag (Non-interactive)** — implemented as a `View`, not a `Button`
- Background: saturated accent (`Color.spotMint`, `Color.spotUltraviolet`, etc.)
- Text: black or white depending on background luminance
- Border radius: `20pt` (tighter than buttons — this is the *text pill*)
- Font: Space Mono 11pt / 600 UPPERCASE, `.tracking(1.8)`
- Padding: ~`4×10pt`

### Cards & Containers

**StoryStream Tile** (used for session history items, trainee list, program list)
- Background: either `Color.spotCanvas` + 1pt white overlay stroke, OR a saturated accent fill
- Border radius: `20pt` (standard) or `24pt` (feature) via `.clipShape(RoundedRectangle(cornerRadius: …))`
- Border (on dark): `.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.spotWhite, lineWidth: 1))`
- Padding: `EdgeInsets(top: 24, …, bottom: 24, …)` to 32pt interior
- Press: no `.scaleEffect`, no `.offset` — the headline `Text` color transitions to `Color.spotDeepLink`. Implement via custom `ButtonStyle` if the whole tile is tappable.
- Animation: `.easeOut(duration: 0.15)` on color only

**Feature Card (Top Story)**
- Background: `Color.spotCanvas` with 1pt hairline overlay, OR full-bleed color accent
- Border radius: `24pt`
- Padding: 32pt+
- Image inside: `.clipShape(RoundedRectangle(cornerRadius: 4))` when nested
- Press: text color shift only; image stays static

**StoryStream Rail (Timeline)** — central to the trainer's monitoring view
- Implement as a `LazyVStack` (not `List` — `List` cannot draw the continuous rail cleanly)
- A vertical 1pt rule (`Color.spotPurpleRule` or `Color.spotWhite`) runs along the leading edge via a leading `.overlay` or a `Rectangle().frame(width: 1)` sibling
- Timestamps sit on the left rail in Space Mono 11pt / 500 / UPPERCASE / `.tracking(1.1)`
- Each entry is a pill-cornered rectangle separated from its neighbors by 12–16pt vertical gap (`spacing: 12` on the VStack)

### Inputs & Forms

> Implemented as `InputField` in `DesignSystem/Components/` wrapping `TextField` / `SecureField` with the design system styling and a `@FocusState`-aware border color.

- **Default**: `Color.spotCanvas` background, `.overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.spotWhite, lineWidth: 1))` (or `Color.spotTextSecondary` for quieter forms), 2pt corner radius (tight, newspaper-form feel), Space Grotesk 15pt text in `Color.spotTextPrimary`, placeholder in `Color.spotTextSecondary`. Min height 44pt.
- **Focused** (driven by `@FocusState`): border becomes `Color.spotMint`, optional inner 1pt `Color.spotUltraviolet` ring on deep focus. No glow, no `.shadow`.
- **Error**: border becomes `Color.spotUltraviolet` (ultraviolet doubles as error/alert here, not red).
- **Animation**: `.animation(.easeOut(duration: 0.15), value: isFocused)` on border color.

### Navigation

iOS does not have a top web-style nav bar. The system maps as follows:

- **Wordmark masthead**: rendered as a hero header inside `RootView` / home screens via a custom `WordmarkHeader` view — never a `.navigationTitle`. Manuka (Anton) at 60–107pt depending on size class.
- **`NavigationStack` titles**: kept minimal. Use `.toolbar { ToolbarItem(placement: .principal) { Text("…").font(.spotMonoLabel).textCase(.uppercase).tracking(1.5) } }` for inline titles instead of the default system title.
- **Tab bar**: `TabView` with `.tabItem`. Selected indicator is an inset 1pt mint underline drawn as a `.overlay(alignment: .top) { Rectangle().fill(Color.spotMint).frame(height: 1) }` on the active tab — custom `TabView` styling required (use a wrapper view, not the default chrome).
- **Press / selection**: text transitions from `Color.spotTextPrimary` to `Color.spotDeepLink`. No underline grows in — color shift only.
- **Active section**: marked by a 1pt mint underline (top-inset on the tab bar, bottom-inset on header tabs).

### Image Treatment

- **Aspect ratios**: 16:9 for hero, 4:3 for mid-feed, 1:1 for avatars — applied via `.aspectRatio(16/9, contentMode: .fill)`.
- **Corners**: always rounded to match the parent card — 3pt, 4pt, or inherit 20pt / 24pt from the tile. `.clipShape(RoundedRectangle(cornerRadius: …))`.
- **Frame**: 1pt `Color.spotImageFrame` or `Color.spotWhite` overlay stroke, giving a "contained Polaroid" feel.
- **Full-bleed**: only within color-block tiles, where the `Image` runs to the padded edge of the accent fill.
- **Press / animation**: static — no `.scaleEffect`, no `.opacity` shift. The associated headline is the only interactive response.
- **Loading**: use `AsyncImage` with a `Color.spotSlate` placeholder. No lazy-eager distinction needed (SwiftUI's view recycling handles offscreen behavior).

### StoryStream Timeline Item (Distinctive)

```
LazyVStack(spacing: 12) {
    ForEach(items) { item in
        HStack(alignment: .top, spacing: 12) {
            Text(item.timestamp)           // mono, uppercase, .tracking(1.1)
                .font(.spotMonoTimestamp)
                .foregroundStyle(.spotTextSecondary)
                .frame(width: 56, alignment: .leading)
            StoryTile(item)                // 20pt-radius card
        }
        .overlay(alignment: .leading) {    // the rail
            Rectangle()
                .fill(Color.spotPurpleRule)
                .frame(width: 1)
        }
    }
}
```

## 5. Layout Principles

### Spacing System

Defined in `DesignSystem/Tokens/Spacing.swift` as `CGFloat` constants.

- **Base unit**: 8pt.
- **Scale**: 1, 2, 4, 5, 6, 8, 9, 10, 12, 14, 15, 16, 20, 24, 25pt.
- **Section padding**: 32–64pt vertical between major sections. StoryStream items themselves are tighter — 12–16pt gaps.
- **Card padding**: 20–32pt interior. Feature cards expand to 40–48pt.
- **Inline spacing**: kickers sit ~6–10pt above headlines; headlines sit ~10–14pt above decks; timestamps sit ~6–8pt below decks.
- **Micro-scale**: The 2/4/5/6/9/10pt values are used inside buttons, pills, and tight label clusters, not in the screen-level grid.

### Grid & Container (iOS)

iOS has no fixed grid system. The translation:

- **iPhone (compact width)**: single column with 20–24pt horizontal screen padding (use `Spacing.screenPadding = 20`).
- **iPad / regular width**: two-column for StoryStream feeds via `LazyVGrid(columns: [.flexible(), .flexible()], spacing: 16)`; feature tiles span both columns via `.gridCellColumns(2)`.
- **Outer screen padding**: 20pt iPhone / 32pt iPad — driven by `@Environment(\.horizontalSizeClass)`.
- **Inter-item gaps**: 12–16pt inside StoryStream, 16–24pt between major sections.

### Whitespace Philosophy

SpotMe treats whitespace like a club DJ treats silence — as a dramatic reset between loud moments. The canvas is so dark and the accents are so saturated that even 32pt of empty `Color.spotCanvas` between two tiles acts as a palette cleanser. The screen is not airy like Apple Health; it's **paced**, with loud hazard-color blocks interrupting stretches of near-black. Whitespace carries the rhythm, not the elegance.

### Border Radius Scale

Defined in `DesignSystem/Tokens/CornerRadius.swift`.

- **2pt** — inputs, small badges (typewriter tag feel)
- **3pt** — inline images
- **4pt** — nested card images and small button variants
- **20pt** — standard pill cards and color-block tiles
- **24pt** — feature tile radius and primary button pill
- **30pt** — large promotional buttons
- **40pt** — outlined CTA pills (loudest pill in the system)
- **`Capsule()`** — avatar circles, icon buttons, and full-pill controls

Eight discrete radius values is deliberate: the rhythm between 2pt typewriter tags, 20pt pill cards, and 40pt outlined buttons creates a "nested scale" where every component announces its hierarchy through its corners. **Apply via `RoundedRectangle(cornerRadius: CornerRadius.tile)` or `.clipShape(RoundedRectangle(…))`** — never inline a raw radius value.

## 6. Depth & Elevation

SwiftUI's `.shadow()` modifier is **banned** in this codebase except for the optional 1pt overlay ring documented at level 5. The Verge identity is built on color-as-elevation, and SwiftUI shadows look soft and Material-flavored — wrong voice.

| Level | SwiftUI Treatment | Use |
|---|---|---|
| 0 | None | Default `Color.spotCanvas` text |
| 1 | Resting interactive (no overlay) | Reset state |
| 2 | `.overlay(RoundedRectangle(cornerRadius: r).stroke(Color.spotWhite, lineWidth: 1))` or `Color.spotImageFrame` | Image frames and quiet card outlines |
| 3 | `.overlay(…)` with `Color.spotMint`, 1pt | Active button outlines, focused tiles |
| 4 | `.overlay(…)` with `Color.spotUltraviolet`, 1pt | Promotional / alternate state outlines |
| 5 | `.overlay(RoundedRectangle(…).stroke(Color.black.opacity(0.33), lineWidth: 1))` | The single "atmospheric" ring — applied to layered cards |
| 6 | `.overlay(alignment: .bottom) { Rectangle().fill(…).frame(height: 1) }` (or `.top` for tab bar) | Active tab / nav underline — signature inset stroke |
| 7 | Solid `.background(Color.spotMint)` / Ultraviolet / White / saturated accent fill | Story-tile "elevation" via color, not shadow |

### Decorative Depth Rules
- **1pt inset underline** on active tabs / segmented controls (mint, black, or white depending on context)
- **Subtle 1pt overlay ring** at `Color.black.opacity(0.33)` on stacked cards — only effect that faintly resembles a shadow
- **No `LinearGradient`, no `.shadow`, no `.blur`** anywhere. The hazard-tape aesthetic breaks if anything fades softly.

## 7. Do's and Don'ts

### Do
- **Do** lock the app to dark mode with `.preferredColorScheme(.dark)` at the `WindowGroup` level. There is no light mode.
- **Do** use `Color.spotMint` and `Color.spotUltraviolet` as hazard accents — buttons, borders, active states, and saturated color-block tiles.
- **Do** use Manuka (Anton) exclusively at 60pt+ for hero headlines. Anything smaller is a bug.
- **Do** round everything: 20pt for cards, 24pt for feature cards, 30–40pt for pill buttons.
- **Do** use Space Mono for UPPERCASE labels, timestamps, kickers, and button text. Enforce with `.textCase(.uppercase)` — lowercase mono doesn't exist here.
- **Do** apply `.tracking(1.5...1.9)` to every ALL-CAPS label — this is the signature.
- **Do** use saturated color-block tiles to elevate a story — never `.shadow`.
- **Do** use `Color.spotDeepLink` as the **press** color (via `ButtonStyle.configuration.isPressed`) on every interactive headline / link.
- **Do** apply the StoryStream timeline rail (1pt `Color.spotPurpleRule` or `Color.spotWhite` `Rectangle`) on feed views.
- **Do** use thin-weight (300) Space Grotesk at 19–20pt with `.tracking(1.9)` for "fashion-whisper" capitalized eyebrows.
- **Do** centralize every color in `Colors.swift`, every font in `Typography.swift`, every radius in `CornerRadius.swift`. **Never inline.**

### Don't
- **Don't** allow a light background. The dark canvas is the product.
- **Don't** use `.shadow()` for elevation. Use `.overlay(…)` strokes or saturated accent fills.
- **Don't** use square corners. Every interactive and content container is rounded.
- **Don't** use Manuka / Anton for UI, buttons, or body copy. Strictly display.
- **Don't** use lowercase mono. Space Mono is always paired with `.textCase(.uppercase)`.
- **Don't** let mint and ultraviolet appear as background washes — they're hazard accents, not canvas tints.
- **Don't** use `LinearGradient` / `RadialGradient` / `.blur` anywhere.
- **Don't** introduce new accent colors outside the declared mint / purple / yellow / pink / orange palette.
- **Don't** pair Manuka with Newsreader in the same headline cluster — Manuka is the only display shout, serif pulls are reserved for body moments.
- **Don't** use `Color.spotMint` text on `Color.spotCanvas` background at under 16pt — contrast vibrates at small sizes.
- **Don't** use `.scaleEffect` or `.offset` on press states. Color-only response.
- **Don't** add `.hover {…}` modifiers. They're no-ops on iOS — wasted code.

## 8. Responsive Behavior (iOS)

iOS does not have CSS-style pixel breakpoints. The system maps to **size classes** via `@Environment(\.horizontalSizeClass)` and `@Environment(\.verticalSizeClass)`.

### Size Classes & Device Mapping

| Size Class | Typical Device | Layout Behavior |
|---|---|---|
| Compact width × Regular height | iPhone portrait (all models) | Single column, full-width StoryStream tiles, hamburger-free nav (TabView only) |
| Compact width × Compact height | iPhone landscape (smaller models) | Single column, compressed vertical padding (32pt → 16pt) |
| Regular width × Regular height | iPad portrait/landscape, iPhone Pro Max landscape | 2-column StoryStream grid via `LazyVGrid`, expanded outer padding (20pt → 32pt) |

### Type Scaling Per Size Class

- **Hero Wordmark**: 107pt on regular width, 60pt on compact width portrait, 48pt on compact width compact height (iPhone landscape). Use `@Environment(\.horizontalSizeClass)` to pick.
- **Large Headlines**: 34pt regular / 24pt compact.
- **Body**: fixed across size classes; relies on Dynamic Type for user accessibility scaling.
- **Mono labels**: pinned at 10–12pt regardless of size class — they don't shrink further or they become unreadable.

### Touch Targets

- **Primary pill buttons (`SpotPrimaryButtonStyle`)**: min height **56pt**. Above the iOS HIG 44pt minimum because trainee UX requires generous targets (sweaty hands, gym gloves, focus on lifting). This is a hard rule — never override.
- **Secondary / tertiary buttons**: min 44pt.
- **Tab bar items**: iOS provides 49pt default.
- **Inline text links**: pad to 44pt tap area via `.contentShape(Rectangle())` and `.padding(.vertical, …)`.

### Collapsing Strategy

- **Tab bar**: present on all sizes. No drawer / hamburger pattern — `TabView` is the native nav primitive.
- **Grid**: 1-column on compact, 2-column on regular via conditional `LazyVStack` vs `LazyVGrid`.
- **Spacing**: section padding tightens from 64pt → 32pt → 20pt as height contracts.
- **Color tiles**: accent blocks never lose saturation across size classes — they just reflow to full width on compact.

### Image Behavior

- `AsyncImage` for remote, bundled `Image` for assets. No `srcset` equivalent needed.
- Aspect ratios preserved across size classes via `.aspectRatio(contentMode: .fill)`.
- Images inside color-block tiles inherit the tile's inner radius (4pt nested or 20pt full).

## 9. Agent Prompt Guide (SwiftUI)

### Quick Color Reference (Swift identifiers)

| Role | Use |
|---|---|
| Primary CTA fill | `Color.spotMint` |
| Background (Canvas) | `Color.spotCanvas` |
| Secondary Hazard | `Color.spotUltraviolet` |
| Heading Text | `Color.spotTextPrimary` (white) |
| Body Text | `Color.spotTextPrimary` or `Color.spotTextMuted` |
| Secondary Text / Metadata | `Color.spotTextSecondary` |
| Card Border (on dark) | `Color.spotWhite` 1pt overlay |
| Card Border (on mint) | `Color.spotMintBorder` 1pt overlay |
| Press State (links/headlines) | `Color.spotDeepLink` |

### Example Component Prompts

1. **"Build a StoryStream timeline item on `Color.spotCanvas`: a 20pt-radius `RoundedRectangle` with a 1pt `Color.spotWhite` `.overlay(…stroke)`, a Space Mono 11pt UPPERCASE timestamp on the left rail with `.tracking(1.1)`, a 12pt UPPERCASE eyebrow in `Color.spotMint` with `.tracking(1.8)`, and a 24pt Space Grotesk 700 headline in `Color.spotWhite` below. No `.scaleEffect`, no `.shadow` — only press transitions the headline color to `Color.spotDeepLink` via a custom `ButtonStyle`."**

2. **"Implement `SpotPrimaryButtonStyle`: `Capsule()` background `Color.spotMint`, label in `Color.spotBlack` with `Font.spotMonoButton` and `.tracking(1.5)`, `EdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24)`, min height 56pt. On `configuration.isPressed`: background becomes `Color.white.opacity(0.2)`, 1pt overlay ring at `Color(white: 0.76)`. Animate with `.easeOut(duration: 0.18)`."**

3. **"Build a feature hero header: 107pt Anton `Text` in `Color.spotWhite` with `.tracking(1.07)`, a 20pt Space Grotesk 300 UPPERCASE eyebrow above with `.tracking(1.9)` in `Color.spotTextSecondary`, on `Color.spotCanvas` with 64pt vertical padding. Hero text uses `.dynamicTypeSize(.medium)` (locked) to prevent accessibility scaling on the display role."**

4. **"Create a color-block accent tile filled with `Color.spotUltraviolet.opacity(0.9)`, 24pt radius via `RoundedRectangle`, white text, a Space Mono 11pt UPPERCASE category label at the top with `.tracking(1.5)`, and a 32pt Space Grotesk 400 capitalized headline with `.tracking(0.32)` below. Padding 32pt interior."**

5. **"Implement `SpotSecondaryButtonStyle`: `Capsule()` background `Color.spotSlate`, label `Color.spotTextMuted` Space Grotesk 16pt, 10×24pt padding, min height 44pt. On press: invert to `Color.white.opacity(0.2)` bg with `Color.spotBlack` text and 1pt `Color(white: 0.76)` overlay ring."**

### Iteration Guide

When refining existing SwiftUI screens against this design system:

1. **Audit the canvas.** If you see `.background(Color.white)` or `.background(.thinMaterial)` anywhere, flatten to `Color.spotCanvas`. There is no light mode and no Material chrome.
2. **Audit corners.** Every `RoundedRectangle` should land on a `CornerRadius` token (2/3/4/20/24/30/40) or `Capsule()`. Free-form radii break the voice.
3. **Audit shadows.** Strip every `.shadow(…)` modifier that isn't an explicit level-5 ring or level-6 inset underline. Color-driven elevation only.
4. **Audit type roles.** Anton only ≥60pt. Space Mono only with `.textCase(.uppercase)`. Space Grotesk 300 at 19–20pt should have `.tracking(1.9)`. Newsreader only for body/magazine moments, never UI.
5. **Audit accent usage.** Mint and ultraviolet should appear as hazard accents — buttons, 1pt overlay strokes, active underlines, saturated tile fills. If they're appearing as backgrounds for non-CTA elements, correct.
6. **Audit labels.** Every kicker, timestamp, category tag, and button label should be `.textCase(.uppercase)` with `.tracking(1.1…1.9)`. Missing tracking = missing voice.
7. **Audit press response.** Every tappable headline / link should use a `ButtonStyle` that transitions text color to `Color.spotDeepLink` on `configuration.isPressed`. No `.scaleEffect`, no `.opacity`. Any other press response is drift.
8. **Audit dynamic type.** Display roles must be `.dynamicTypeSize(.medium)` locked. Body roles must allow `.medium...accessibility2`.
9. **Audit centralization.** No inline hex (`Color(hex: "…")`), no inline font sizes (`Font.system(size: 24)`), no inline radii (`cornerRadius: 18`). Everything flows through `Colors.swift`, `Typography.swift`, `CornerRadius.swift`, `Spacing.swift`.

## 10. iOS Implementation Notes

### Locked Dark Mode

Apply at the root:

```swift
@main
struct SpotMeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)   // 🔒 locked dark — never .light, never .none
                .tint(Color.spotMint)          // global tint for system-driven UI elements
        }
    }
}
```

In the Asset Catalog, define every brand color as **Any Appearance only** (no Dark variant) — they must render identically regardless of system setting.

### Custom Font Registration

1. Drop `.ttf` / `.otf` files into `SpotMe/Resources/Fonts/`. Add to the Xcode target's `Copy Bundle Resources` build phase.
2. In `Info.plist`, add:
   ```xml
   <key>UIAppFonts</key>
   <array>
       <string>Anton-Regular.ttf</string>
       <string>SpaceGrotesk-Light.ttf</string>
       <string>SpaceGrotesk-Medium.ttf</string>
       <string>SpaceGrotesk-Bold.ttf</string>
       <string>SpaceMono-Regular.ttf</string>
       <string>SpaceMono-Bold.ttf</string>
       <string>Newsreader-Regular.ttf</string>
   </array>
   ```
3. Verify the registered family name by inspecting `UIFont.familyNames` at app startup once — the file's PostScript name and family name may differ.
4. Reference exclusively via `Font.custom("PostScriptName", size: …)` in `Typography.swift`.

### Color Asset Catalog vs In-Code

For SpotMe, **define colors in code** (`Colors.swift`) rather than the Asset Catalog. Reasons:
- Single source of truth alongside Typography and CornerRadius
- No risk of accidentally adding a "Dark" variant that breaks the locked-dark identity
- Easier to diff in version control
- Asset Catalog is reserved for app icon, launch screen imagery, and bundled illustrations only

### ButtonStyle Convention

All buttons in this codebase are implemented as `ButtonStyle` conformances in `DesignSystem/Components/`. Never inline a `.background()`, `.foregroundStyle()`, or `Capsule()` on a `Button`'s label — that's a sign the style should be promoted to a named `ButtonStyle`.

```swift
struct SpotPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.spotMonoButton)
            .tracking(1.5)
            .textCase(.uppercase)
            .foregroundStyle(configuration.isPressed ? Color.spotBlack : Color.spotBlack)
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, Spacing.lg + 8)
            .background(
                Capsule()
                    .fill(configuration.isPressed ? Color.white.opacity(0.2) : Color.spotMint)
            )
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SpotPrimaryButtonStyle {
    static var spotPrimary: SpotPrimaryButtonStyle { .init() }
}

// Usage:
Button("Get Started") { … }
    .buttonStyle(.spotPrimary)
```

### Component Ownership Map

| Concern | Owner File |
|---|---|
| All colors | `DesignSystem/Tokens/Colors.swift` |
| All fonts / type roles | `DesignSystem/Tokens/Typography.swift` |
| All spacing | `DesignSystem/Tokens/Spacing.swift` |
| All radii | `DesignSystem/Tokens/CornerRadius.swift` |
| ButtonStyles | `DesignSystem/Components/Buttons/…ButtonStyle.swift` |
| Cards, Tiles | `DesignSystem/Components/Cards/…` |
| Input fields | `DesignSystem/Components/InputField.swift` |
| Pill tags | `DesignSystem/Components/PillTag.swift` |
| Wordmark header | `DesignSystem/Components/WordmarkHeader.swift` |
| StoryStream rail | `DesignSystem/Components/StoryStreamRail.swift` |

If a screen needs styling that isn't already in `DesignSystem/`, the correct move is to add it to `DesignSystem/` first, then use it — not to inline new styles in the screen.
