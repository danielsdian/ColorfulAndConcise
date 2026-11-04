---

# 🌈 Colorful & Concise: Ultimate AIOStreams & Nuvio Config

Welcome to **Colorful & Concise**, a beautifully crafted and highly optimized configuration suite for [AIOStreams](https://github.com/Viren070/AIOStreams) and [Nuvio](https://github.com/NuvioMedia/NuvioMobile).

Tired of cluttered stream lists, messy torrent names, and redundant quality badges? This setup completely overhauls your UI to give you a clean, readable, and visually stunning streaming experience.

---

## ✨ Features

### 🛡️ 1. The Ultimate Nuvio Badges (`badge.json`)

The Nuvio badge configuration is powered by a custom-built, bulletproof Regex engine designed to be 100% crash-proof and extremely fast.

* **Airtight Hierarchy (No Double Badges):** If a superior format is detected, lower-tier formats are instantly suppressed to save screen space.
* *Example:* If a file is **4K**, the **1080p** badge hides. If a file has **TrueHD**, the **DD+** badge hides.


* **Bulletproof Boundaries:** Captures tags flawlessly whether the ripper used spaces, dots, underscores, or brackets (e.g., `[1080p]`, `.HEVC.`, `_DTS-HD_`).
* **Sticky Audio Tags:** Perfectly parses audio codecs that are directly attached to their channel numbers (e.g., `DDP5.1`, `AAC2.0`).
* **Aesthetic Polish:** Custom-designed image badges and official brand hex colors for streaming platforms (Netflix Red, Prime Blue, Max Purple, etc.).

### 🍿 2. AIOStreams Formatter (`Sterzeck_formatter.json`)

Transforms raw, ugly torrent names into a neat, easily scannable format optimized with advanced AIOStreams features.

* **Emoji Integration:** Uses intuitive emojis to quickly identify video quality, audio codecs, file size, and release groups.
* **Clean Layout & Minimal Runtimes:** Organizes stream data into logical lines and strips unnecessary seconds from runtimes (e.g., displaying `1h 47m` or `23m`) to reduce visual clutter.
* **Anime & Absolute Numbering Support:** Automatically detects anime releases (`🌸 Anime`) and translates standard Western episode strings into precise Japanese absolute episode numbers (e.g., `🌸 Ep. 144`).
* **Real Audio Probing & Fallbacks:** Pulls actual probed audio tags (`TrueHD`, `DD+`, etc.) directly from media info with smart fallbacks and duplicate removal (`::unique`).
* **Precise Storage & Smart Badging:** Displays file sizes in accurate binary format (`GiB`/`MiB`), alongside dynamic indicators like `🔥 New` (<48h releases) and `✅ Proper` fixes.

---

## 📸 Previews

---

## ⚙️ Installation Instructions

### Installing the Nuvio Badges

1. Open your Nuvio Dashboard.
2. Navigate to **Settings** > **Badges**.
3. Look for the **Import/Export** section.
4. Paste the raw URL of the `badge.json` file to import it:
```text
https://raw.githubusercontent.com/danielsdian/ColorfulAndConcise/main/Sterzeck_badge.json

```


5. Click Import and save your changes.

### Installing the AIOStreams Formatter

1. Open your AIOStreams Configuration page.
2. Navigate to the **Formatter** section.
3. Choose the option to import a custom formatter configuration.
4. Paste the raw URL of the `Sterzeck_formatter.json` file:
```text
https://raw.githubusercontent.com/danielsdian/ColorfulAndConcise/main/Sterzeck_formatter.json

```


5. Apply the formatter and sync your add-on.

## 🛠️ Under the Hood (For Regex Nerds)

The badge.json file utilizes highly optimized Negative Lookbehind logic (e.g., `(?<![a-z0-9])` and `(?<![\s\S])`). By replacing traditional, heavy start-of-string lookaheads and explicit character class boundaries, this configuration prevents infinite backtracking and massively improves parsing performance. It scans efficiently across multi-line text blocks, ensuring lightning-fast word boundary detection and guaranteeing 100% tag detection with zero false positives.

Meanwhile, the `Sterzeck_formatter.json` leverages AIOStreams' native Optional Groups (`{? ?}`), object track plucking (`::pluck('tags')`), and conditional formatting engines to deliver high-performance dynamic string rendering without template errors.

## 🤝 Contributing

Feel free to open an issue or submit a pull request if you find a rare edge-case filename that isn't being caught, or if a new major codec is released that needs a badge!

## Enjoy your clean and colorful media library! 🎬
