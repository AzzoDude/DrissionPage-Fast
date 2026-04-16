# DrissionPage-Fast (Windows AMD64)

A high-performance, pre-compiled version of the [DrissionPage](https://github.com/g1879/DrissionPage) automation library. This project uses **Nuitka** to compile the pure Python source into a native Windows binary (`.pyd`) for maximum execution speed.

## 🚀 Key Features
- **Speed Boost**: Significantly faster internal logic execution compared to the standard source version.
- **Native Performance**: Leverages machine-level optimizations for attribute lookups and browser interaction logic.
- **Zero Configuration**: Simple drop-in replacement for the original `DrissionPage`.
- **Automated Builds**: Includes GitHub Actions workflow for consistent Windows AMD64 binaries.

## 🛠️ How it was built
This project compiles the official `DrissionPage` source using a highly optimized Nuitka configuration:
- `--module`: Converts the entire package into a single extension module.
- `--lto=yes`: Enables Link Time Optimization for maximum performance.
- `--assume-yes-for-downloads`: Fully automated compilation process.

## 📦 Usage
1. Download the compiled `.pyd` from the `dist/` folder or GitHub Actions artifacts.
2. Place the `.pyd` file in your project's root directory (next to your script).
3. Use it exactly like the original:
   ```python
   from DrissionPage import ChromiumPage
   page = ChromiumPage()
   page.get('https://example.com')
   ```

## 🏗️ Building Locally
You can rebuild the module at any time using the included automation script:
```powershell
.\Scripts\build.bat
```
This script will:
1. Clone the latest `DrissionPage` source if missing.
2. Initialize a virtual environment and install all dependencies.
3. Run the Nuitka compilation process.

## ⚖️ License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Original DrissionPage code is subject to its own license terms.
