# Millennialisms for Vale

A distributable Vale package that flags millennial-style slang, meme phrasing, pet-speech, and emotional hyperbole.

It is packaged as a **complete Vale package**:
* `.vale.ini`
* `styles/`
* `styles/config/vocabularies/`

## What this package includes

* `Millennialisms.AnimalSlang`
* `Millennialisms.InternetLifestyleSlang`
* `Millennialisms.EmotionalHyperbole`
* `Millennialisms.OptionalBroadTerms` - disabled by default because it is noisier

## Design choices

### 1. Split rules by category

Instead of one giant rule, the package is split into separate rules so you can:
* disable only one category
* tune severity per category
* add or remove suggestions without touching unrelated terms

### 2. Quote-safe by default

All rules exclude block quotes by default via `scope: ~blockquote`.

This means text inside Markdown block quotes is not flagged, which is useful for:
* cited language
* examples
* intentionally quoted slang

### 3. Humour escape hatch

For intentionally playful copy, use block ignores:

```md
<!-- vale-ignore-Millennialisms:start -->
Doggo did a heckin zoomies and I am literally dead.
<!-- vale-ignore-Millennialisms:end -->
```

### 4. Project-level exceptions

The package ships with a vocabulary: `styles/config/vocabularies/MillennialismsExceptions/accept.txt`

Add allowed expressions there when your project intentionally permits them.

Example:

```txt
(?i)doggo
(?i)self-care
```

### 5. Extendable autofix suggestions

Each rule uses `extends: substitution` with `action: replace`.

That gives you quick-fix suggestions in Vale-aware editors and CLIs. The suggestions are intentionally conservative and easy to edit.

Example rule entry:

```yaml
swap:
  '(?i)\bdoggo\b': dog
```

If you prefer stricter enforcement, change the replacement suggestion to your own house style.


## Installation

### Primary: use the GitHub release asset URL directly

Vale supports remote packages via URLs. This is the recommended installation method.

Add the package directly to your `.vale.ini`:

```ini
Packages = https://github.com/davidsneighbour/dnb-vale-millennialisms/releases/latest/download/Millennialisms.zip

[*.{md,markdown,mdx,adoc,txt,rst,html}]
BasedOnStyles = Millennialisms
```

Then run:

```bash
vale sync
```

This will:

* download the latest package automatically
* cache it locally
* keep your setup clean without vendored files

### Using multiple packages (merge order matters)

Vale merges configurations **from right to left**.

Example:

```ini
Packages = Microsoft,
https://github.com/davidsneighbour/dnb-vale-millennialisms/releases/latest/download/Millennialisms.zip
```

In this setup:

1. `Microsoft` provides the base rules
2. `Millennialisms` overrides or extends them

This allows you to layer:

* upstream styles (Microsoft, Google, etc.)
* your organisation defaults
* this package as a tone filter

### Development: use the repo directly

For local development or contributions:

```ini
Packages = ../path/to/dnb-vale-millennialisms

[*.{md,markdown,mdx,adoc,txt,rst,html}]
BasedOnStyles = Millennialisms
```

Then run:

```bash
vale sync
```

### Development: build the package locally

From this repository:

```bash
./scripts/build-release-zip.sh
```

This creates:

`dist/Millennialisms.zip`

Then reference it:

```ini
Packages = ./vendor/Millennialisms.zip

[*.{md,markdown,mdx,adoc,txt,rst,html}]
BasedOnStyles = Millennialisms
```

Run:

```bash
vale sync
```

### Pinning a version (optional)

If you need reproducible builds, replace `latest` with a version tag: `https://github.com/davidsneighbour/dnb-vale-millennialisms/releases/download/v0.0.0/Millennialisms.zip`. Replace `v0.0.0` with the desired version.

## Recommended local overrides

### Enable the optional broad rule

```ini
[*.{md,markdown,mdx,adoc,txt,rst,html}]
Millennialisms.OptionalBroadTerms = YES
```

### Turn one rule off entirely

```ini
[*.{md,markdown,mdx,adoc,txt,rst,html}]
Millennialisms.EmotionalHyperbole = NO
```

### Change severity locally

```ini
[*.{md,markdown,mdx,adoc,txt,rst,html}]
Millennialisms.AnimalSlang = error
```
