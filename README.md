# PLC Trend Tool

**Real-Time Tag Trending for Allen-Bradley PLCs**

A portable Windows desktop application for trending PLC tag data in real time. Connects to ControlLogix, CompactLogix, Micro800, SLC 500, MicroLogix, and PLC-5 controllers via Ethernet/IP and charts live values with full data export capability.

- **ControlLogix / CompactLogix / Micro800** — automatic tag discovery via [pylogix](https://github.com/dmroeder/pylogix)
- **SLC 500 / MicroLogix / PLC-5** — automatic data file scanning via [pycomm3](https://github.com/ottowayi/pycomm3)

Built by [Southern Automation Solutions](https://southernautomationsolutions.com) — Valdosta, GA

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D6?logo=windows)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Quick Start (End User)

1. Copy `PLC_Trend_Tool.exe` to any Windows 10/11 PC
2. Double-click to run — no installation required
3. Enter the controller IP address and click **Connect** (use **+ Add Controller** for more PLCs — each row connects on its own)
4. Verify the connection details under each controller row on the PLC Connection page
5. Navigate to the Trend view using the sidebar
6. Select tags from the built-in tag browser panel
7. Click **▶ Start Trend** to begin collecting data

No Python, no drivers, no admin rights required. Single `.exe`, fully portable.

---

## Supported Controllers

| Controller Family | Models | Tag Discovery | Library |
|---|---|---|---|
| **ControlLogix** | 1756-L6x, L7x, L8x (5x80) | ✅ Full tag list + UDTs/AOIs | pylogix |
| **CompactLogix** | 1769-L1x, L2x, L3x, 5370, 5380 | ✅ Full tag list + UDTs/AOIs | pylogix |
| **Micro800** | Micro820, Micro850 | ✅ Tag list | pylogix |
| **SLC 500** | 5/03, 5/04, 5/05 (Ethernet) | ✅ Auto data file scan | pycomm3 |
| **MicroLogix** | 1100, 1200, 1400, 1500 | ✅ Auto data file scan | pycomm3 |
| **PLC-5** | PLC-5/E series (Ethernet) | ✅ Auto data file scan | pycomm3 |

> SLC 500, MicroLogix, and PLC-5 require an Ethernet port on the controller. Serial-only models are not supported.

---

## Features

### PLC Connection
- **Multiple controllers at once** — up to 8 rows, each with its own name, controller type, IP, slot, and **Connect / Disconnect** button; rows operate independently and can mix controller families
- Supports Allen-Bradley **ControlLogix**, **CompactLogix**, **Micro800**, **SLC 500**, **MicroLogix**, and **PLC-5** controllers
- Configurable processor slot for multi-slot ControlLogix chassis
- Validates connection with device identity query (Logix) or test read (SLC)
- Displays device name, firmware revision, and connection details
- Stays on the connection page after connecting so you can verify status before navigating

### Live Tag Browser
- **Controller tabs** — one animated tab per connected controller across the top of the tag list; the selected tab is highlighted by a sliding pill, and each tab shows a status dot (green OK, blue loading, red no response) and its selected-tag count. Each controller keeps its own tree, expansion state, and search text
- **Logix controllers:** Retrieves full controller and program-scoped tag lists with data types, including UDT and AOI expansion
- **SLC 500 / MicroLogix / PLC-5:** Automatically scans all 256 data files to discover what exists — no manual address entry needed
  - Probes default files (0–8) and user-created files (9–255) using typed probes (N, F, B, T, C, R, ST, A, L) to accurately detect only files that exist in the program
  - Integer and Binary words (N, B, O, I, S files) are expandable — trend the whole word as a decimal value or expand to select individual bits (/0 through /15)
  - **SLC 500 inputs and outputs are shown by rack slot** (`I:3.0`, `O:2.0/5`), the same way RSLogix 500 shows them. The slot layout is read from the processor; if it can't be read, right-click the Input or Output file to enter it
  - Timer, Counter, and Control elements expand to show sub-elements (.ACC, .PRE, .DN, etc.)
  - Float (F) and Long Integer (L) files display directly as trendable values
  - Scan results cached per session — reconnecting to the same PLC is instant
- Search and filter tags by name or data type
- Checkbox selection with Select All / Clear controls
- **Tags panel is embedded in the trend view** — select tags and watch the chart update in real time, before or during a trend
- Collapsible tag panel with resizable splitter to maximize chart area
- Tags can be added or removed mid-trend without stopping data collection

### Tag Aliases
- Give any tag a plain-language name — the chart legend, cursor read-out, and data table show the alias instead of the raw address (`Filler Supply Pump Running` instead of `I:3.0/0`)
- Set an alias by right-clicking a tag in the tag browser, or by double-clicking (or right-clicking) its row in the data table
- The data table keeps the real address in its own **Address** column, and CSV column titles read `Alias (address)`
- Aliases are saved per controller (by IP address) and come back the next time you connect; they are also stored in `.pytrend` files

### Trend Setup Files
- **Setup: Save** stores the whole trend configuration in a `.trendsetup` file: controllers (name, type, IP, slot), selected tags and their chart order, aliases, per-tag scaling, line color/width/style and chart backgrounds, sample rate, time span, overlay/isolated mode, and the display options
- **Setup: Open** rebuilds that session on any PC: it fills in the connection rows, connects, and puts the same tags on the chart with the same settings — click **Start Trend** and go
- Built for remote support: set up the trend, send the file to the customer, they open it, run it, and send back the exported `.pytrend`
- A `.trendsetup` file dropped onto `PLC_Trend_Tool.exe` opens at startup

### Real-Time Trending
- Background polling thread at configurable sample rates (100 ms to 60 sec)
- Matplotlib chart with auto-scaling, zoom, and horizontal pan
- Live data table showing current value, min, max, and status per tag
- Pause/resume display updates while data continues collecting in the background
- Rolling time window with horizontal scrollbar for history navigation
- Snap-to-live button to jump back to the latest data
- Unlimited data points by default — optional cap configurable in Settings to limit memory usage
- Charts automatically scale to fill available space at any window size

### Session Management
- **↻ New** button on the toolbar resets the entire session — clears all trend data, selected tags, chart state, and tag scales as if the app was closed and reopened
- If still connected to a PLC, the tag browser reloads automatically after reset
- Disconnecting from a PLC also performs a full session reset — no stale data carries over when connecting to a different controller
- Import/export preserves session data for offline review

### Chart Modes
- **Overlay mode** — all tags plotted on a shared axis
- **Isolated mode** — each tag gets its own subplot with synchronized pan/zoom across all subplots
- **Drag-reorder** — Ctrl+drag subplots to rearrange chart order in isolated mode
- Tag colors stay locked to each tag regardless of reorder position

### Chart Customization
- **Trend Properties dialog** with tabs for X-Axis, Y-Axis, and Display settings
- Per-tag Y-axis scaling (auto or manual min/max)
- Configurable time span (30 sec to 1 hour)
- **Line Properties** — right-click any trace to change color, line width, and line style (solid, dashed, dotted, dash-dot)
- In isolated mode, right-click a specific subplot to edit that single tag's line properties
- **Smart cursor** — crosshair with snap-to-nearest-point and value readout tooltip
- **Pan is locked to horizontal only** — no accidental vertical scrolling; zoom still allows full region selection

### Click-to-Inspect (Stopped / Historical)
- When the trend is stopped or viewing an imported file, **left-click anywhere on the chart** to inspect data at that point in time
- The data table updates to show each tag's value at the clicked timestamp
- The "Current" column header changes to display the inspected time (e.g., `@ 13:58:22.450`)
- Works with both stopped live data and imported `.pytrend` files
- Table automatically returns to live values when a new trend is started

### Data Export & Import
- **`.pytrend`** — JSON format with full metadata (PLC IP, controller type, tags, timestamps, sample rate)
- **`.csv`** — standard CSV with timestamp column and one column per tag
- **Import** `.pytrend` files for offline analysis with full chart interactivity
- View mode badge shows **LIVE**, **PAUSED**, **STOPPED**, or **HISTORICAL**

### Theme Support
- Dark and Light modes with SAS brand identity
- Theme toggle in Settings
- Logo automatically swaps between dark/light variants
- All settings persist between sessions

---

## Installation (Development)

### Prerequisites

- **Python 3.10** or newer — [Download Python](https://www.python.org/downloads/)
  - Check the **"Add Python to PATH"** checkbox during installation
- **pip** (included with Python)
- **Windows 10 or 11** (required for CustomTkinter and pylogix networking)

### Clone the Repository

```bash
git clone https://github.com/your-org/plc-trend-tool.git
cd plc-trend-tool
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

This installs:

| Package | Version | Purpose |
|---------|---------|---------|
| `customtkinter` | ≥ 5.2.0 | Modern themed UI framework |
| `pylogix` | ≥ 0.8.0 | ControlLogix / CompactLogix / Micro800 communication |
| `pycomm3` | ≥ 1.2.0 | SLC 500 / MicroLogix / PLC-5 communication |
| `matplotlib` | ≥ 3.7.0 | Chart rendering and interactive plotting |
| `Pillow` | ≥ 9.0.0 | Image handling for logos and icons |
| `pyinstaller` | ≥ 6.0.0 | Builds standalone Windows executable |

> **Note:** `pycomm3` is optional for running from source — the app works without it but SLC/MicroLogix/PLC-5 support will be unavailable. However, **it must be installed before building the .exe** if you want SLC support included in the compiled application. PyInstaller bundles whatever is installed at build time.

### Run from Source

```bash
python plc_trend_tool.py
```

---

## Building the Executable

The included build script handles PyInstaller configuration, asset bundling, and CustomTkinter packaging automatically.

### Build Steps

**Quick way:** double-click `build.cmd` in the source folder you want to build (`Source Code v… (x64)` or `Source Code v… (ARM64)`). It finds the installed Python that matches the folder (x64 or ARM64), installs the dependencies including `pycomm3`, and runs `build.py`. `Build_All.cmd` in the `Source Code` folder builds both, one after the other. Both Pythons must be installed on the build PC to build both versions.

**By hand:**

```bash
pip install -r requirements.txt
pip install pycomm3    # Required for SLC 500/MicroLogix/PLC-5 support in the .exe
python build.py
```

> **Important:** If `pycomm3` is not installed when you build, the .exe will still work for ControlLogix/CompactLogix/Micro800 — but SLC 500, MicroLogix, and PLC-5 connections will show an error. Install it before building to include full controller support.

The executable is created at:

```
dist\PLC_Trend_Tool.exe
```

Copy the `.exe` to a USB drive — it runs standalone on any Windows 10/11 machine with no installation.

### What the Build Script Does

1. Verifies all dependencies are installed
2. Extracts assets from the embedded `assets_data.py` if the `assets/` folder is incomplete
3. Generates `icon.ico` from `icon.png` if needed
4. Locates the CustomTkinter package directory for bundling
5. Runs PyInstaller in `--onefile --windowed` mode with all required hidden imports and data files
6. Reports the output path and file size

### Build Notes

- The resulting `.exe` is typically 25–35 MB (CustomTkinter + matplotlib + pycomm3)
- No external files or DLLs are needed — everything is bundled
- Assets are embedded in `assets_data.py` as base64, so the app is fully self-contained even without the `assets/` folder
- `pycomm3` is automatically detected and bundled by PyInstaller if installed — no extra configuration needed

---

## Project Structure

```
plc-trend-tool/
├── plc_trend_tool.py      # Main application (single-file)
├── assets_data.py         # Embedded assets (base64-encoded logos, icons)
├── build.py               # PyInstaller build script
├── requirements.txt       # Python dependencies
├── LICENSE                # MIT License
├── README.md              # This file
├── .gitignore
└── assets/
    ├── logo.png           # SAS logo — white text (dark mode)
    ├── logo_light.png     # SAS logo — blue text (light mode)
    ├── icon.png           # App icon source (PNG)
    └── icon.ico           # App icon (Windows ICO)
```

---

## Usage Guide

### Connecting to a PLC

Each row on the **PLC Connection** view is one controller. Click **+ Add Controller** to add rows (up to 8); give a row an optional **Name** (e.g. `Kiln`) — it's used on the tag-panel tab and as the `[Kiln]` prefix in the chart legend, data table, and CSV headers whenever more than one controller's tags are on the chart. Connect and disconnect rows independently; disconnecting one controller removes only its tags (an active trend keeps running for the others).

1. Open the app — it starts on the **PLC Connection** view
2. Select the controller type from the dropdown:
   - **ControlLogix** — for any ControlLogix chassis (set the processor slot)
   - **CompactLogix** — slot is usually `0`
   - **Micro800** — Micro820/850 with Ethernet
   - **SLC 500 / MicroLogix** — SLC 500, MicroLogix 1100/1200/1400/1500 (slot is not used)
   - **PLC-5** — PLC-5 E-series with Ethernet (slot is not used)
3. Enter the PLC's IP address (e.g., `192.168.1.10`)
4. Set the processor slot if applicable
5. Click **Connect**
6. For Logix controllers, the tag list loads automatically. For SLC/MicroLogix/PLC-5, a data file scan runs automatically (typically 3–10 seconds) to discover all available data files
7. Navigate to the **Trend** view from the sidebar when ready

### Selecting Tags and Trending

1. Browse or search for tags in the left panel
2. Click tags to select them — the chart updates immediately with empty axes as a preview
3. Adjust the sample rate from the toolbar dropdown
4. Click **▶ Start Trend** to begin data collection
5. Tags can be added or removed while the trend is running — new tags start collecting on the next poll cycle (historical data won't exist for newly added tags)
6. With several controllers connected, switch tabs at the top of the tag panel to pick tags from each one — all selected tags from every controller trend together on the same chart. Controllers are polled in parallel each sample period; a controller that doesn't answer in time is skipped for that sample (gap in its traces, red tab dot) without slowing the others

### SLC / MicroLogix Tag Browser

The tag browser for SLC-type controllers organizes data by file type and number. Each data file appears as an expandable node showing its type and size.

**Integer and Binary words (N, B, O, I, S files)** are expandable with two levels of access:
- Click the expand arrow (▶) to see the word-level checkbox and individual bit checkboxes
- The first entry (marked "word") trends the whole integer as a decimal number
- Entries `/0` through `/15` trend individual bits as BOOL values
- You can trend both the whole word and individual bits simultaneously

**Input and Output files (SLC 500)** are listed by rack slot — `I:3.0`, `I:4.0` — matching RSLogix 500. The tool reads the rack layout from the processor when it scans the data files. If a processor doesn't report its layout, the words appear as `I1:0`, `I1:1` with a "Right-click to set slots" row: right-click the file, choose **I/O Slot Layout...**, and list the slots that hold input (or output) cards, for example `3, 4`, or `1:2, 3, 4:4` when a card uses more than one word. The layout is saved for that controller.

### Tag Aliases

Raw addresses are hard to follow on a trend, so any tag can be given an alias:

1. Right-click the tag in the tag browser and choose **Set Alias...** (or double-click its row in the data table under the chart)
2. Type a name and press Enter

The alias replaces the address on the chart, legend, cursor read-out, and table. The tag browser shows it beside the address, and the table's **Address** column always shows the real address. To change or remove an alias, right-click the tag again. Aliases are remembered per controller IP address, so they are there the next time you connect to that PLC.

**Timers, Counters, and Controls** expand to show their sub-elements (`.ACC`, `.PRE`, `.DN`, `.EN`, etc.) with trendable numeric values and status bits.

**Float (F) and Long Integer (L) files** show directly as trendable values without expansion.

### Saving and Reopening a Trend Setup

1. Connect, pick your tags, and set everything the way you want it (aliases, scaling, line styles, sample rate, chart options)
2. Click **Save** next to **Setup:** on the toolbar and choose where to put the `.trendsetup` file
3. Later — or on another PC — click **Open** next to **Setup:** and pick the file. The tool closes any current connections, fills in the controllers from the file, connects to them, and loads the tags with their saved settings
4. Click **▶ Start Trend**

If a controller can't be reached (for example its IP address is different on site), the tool shows the PLC Connection page. Correct the IP address and click **Connect**; the saved tags load as soon as it connects. A setup file holds no trend data — use **Export** for that.

### Starting a New Session

Click the **↻ New** button on the toolbar to completely reset the application state. This clears all trend data, selected tags, chart lines, and custom settings (scales, colors, line styles). If you're still connected to a PLC, the tag browser reloads fresh. Use this when switching between PLCs or starting a clean trend without leftover data from a previous session.

### Chart Interaction

- **Pan** — click the pan tool in the chart toolbar, then click-drag horizontally (vertical panning is disabled)
- **Zoom** — click the zoom tool then drag a rectangle to zoom into a region
- **Home** — click the home button to reset the view
- **Right-click** — access line properties and chart options from the context menu
- **Ctrl+Drag** (isolated mode) — reorder subplots by dragging them up or down
- **Left-click** (when stopped) — inspect data at the clicked time; values appear in the table below

### Reviewing Data

After stopping a trend or importing a `.pytrend` file:
- Use the scrollbar or pan tool to navigate through the data
- Hover over the chart to see the smart cursor readout
- **Click** on any point to pin its values in the data table
- The table's "Current" header updates to show the exact timestamp you clicked
- Start a new trend to return the table to live values

### Exporting Data

- Click **`.pytrend`** to save a JSON file with full metadata for later import
- Click **`CSV`** to save a standard CSV file compatible with Excel or other tools (aliased tags get the column title `Alias (address)`)
- Click **Import** to load a previously saved `.pytrend` file for offline analysis

---

## Troubleshooting

**Can't connect to PLC**
- Verify the IP address is correct and the PLC is powered on
- Ensure your PC is on the same subnet (e.g., PLC: `192.168.1.10`, PC: `192.168.1.x`)
- Check that the PLC's Ethernet module is configured and has a valid IP
- Try pinging the PLC from a command prompt: `ping 192.168.1.10`
- Make sure the PLC is not faulted — a faulted controller may connect but fail to return tags

**SLC 500 / MicroLogix / PLC-5 won't connect**
- Make sure `pycomm3` was installed before the .exe was built (see Build Steps above)
- The controller must have an Ethernet port — serial-only models (e.g., MicroLogix 1000) are not supported
- Check that no other application (RSLinx, FactoryTalk) has an exclusive connection to the controller
- The data file scan probes N7:0 to verify the connection — if the default Integer file was removed from the program, the scan may fail on initial test but will still discover other files

**Data file scan shows fewer files than expected (SLC/MicroLogix)**
- Only files that actually exist in the PLC program are shown — the scanner uses typed probes (N, F, B, T, C, R, ST, A, L) to verify each file, so empty or non-existent files are excluded
- The scanner does not probe Output (O) or Input (I) types for user files 9–255, as the SLC output/input image table allows reads against non-existent file numbers, which would produce false positives
- Files above #255 are not scanned (SLC limit)

**Tags show "Path segment error"**
- Verify the processor slot number — usually `0` for CompactLogix, check the physical chassis slot for ControlLogix

**Tag browser shows no tags after connecting**
- Check that the PLC is not faulted or in a firmware update state
- Try disconnecting and reconnecting
- Verify you can browse tags in RSLogix/Studio 5000

**Old tags still showing on chart after switching PLCs**
- Click the **↻ New** button on the toolbar to fully reset the session before connecting to a different controller
- Alternatively, disconnect first — disconnecting now performs a full session reset automatically

**"ModuleNotFoundError" when running from source**
- Run `pip install -r requirements.txt` to install all dependencies
- Verify Python is version 3.10 or newer: `python --version`

**Executable won't start or crashes immediately**
- Run from a command prompt to see error output: `PLC_Trend_Tool.exe`
- Ensure you're on Windows 10 or 11
- Try rebuilding with `python build.py`

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Dependencies & Acknowledgments

- [pylogix](https://github.com/dmroeder/pylogix) — ControlLogix / CompactLogix / Micro800 communication
- [pycomm3](https://github.com/ottowayi/pycomm3) — SLC 500 / MicroLogix / PLC-5 communication
- [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter) — Modern tkinter UI framework
- [matplotlib](https://matplotlib.org/) — Scientific plotting library
- [Pillow](https://python-pillow.org/) — Python Imaging Library
- [PyInstaller](https://pyinstaller.org/) — Executable packaging

---

*Southern Automation Solutions — 111 Hemlock St. Ste A, Valdosta, GA 31601*
