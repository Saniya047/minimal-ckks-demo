# Minimal CKKS demo

## Linux (Ubuntu / Debian)

### Prerequisites

Install the required system dependencies:

```bash
sudo apt update
sudo apt install -y build-essential cmake git python3
```

Ensure CMake 3.20 or newer is installed:

```bash
cmake --version
```

### Run the application

Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/Saniya047/minimal-ckks-demo.git
cd minimal-ckks-demo
```

Start the application:

```bash
bash run.sh
```

On the first launch, the script automatically:
- Downloads Microsoft SEAL 3.6.5 into `.deps/`.
- Builds and installs SEAL locally.
- Compiles the CKKS evaluator using CMake.
- Starts the Python application.

**No manual SEAL installation, separate setup script, npm packages, or pip packages are required.**

Once the server starts, open:

**http://127.0.0.1:8094**

Keep the terminal open while using the application to view server logs. Press `Ctrl+C` to stop the server.

**Note:** An internet connection is required for the initial SEAL download. Subsequent launches reuse the local installation. If port `8094` is already occupied, stop the previous server before restarting. If using a proxy, bypass `localhost` and `127.0.0.1`.

Other Linux distributions can use their equivalent package managers to install the required dependencies.

Example: A = `1.5, 2, -3`, B = `4, -1, 0.5`.
Sum ≈ `[5.5, 1, -2.5]`; element-wise product ≈ `[6, -2, -1.5]`.


## Flow and code

1. `static/dashboard.mjs` reads the form. Comments explaining the retained input/form/request/display functions are preserved and clarified from your original file.
2. `static/client.mjs` generates browser-session keys, encodes and encrypts both vectors using SEAL WebAssembly. It returns exactly `cipher_a`, `cipher_b`, and `relin_keys`.
3. The dashboard POSTs that object to `app.py`. Python validates the serialized objects and invokes the native evaluator.
4. `main.cpp` loads the encrypted objects, adds, multiplies, relinearizes and rescales. It returns only encrypted sum and product. `wire.hpp` handles the binary messages between Python and C++.
5. The browser decrypts the returned ciphertexts using its own secret key. The dashboard displays full serialized ciphertext text and the decoded answers.

No coefficient tables, polynomial traces, timers, error charts, downloads, or plaintext comparison calculations are included. Functions and comments for those removed features are absent. Input validation, request validation, key handling and memory cleanup remain necessary.

## Files

- `static/index.html`, `static/style.css`: simple form and four output sections.
- `static/dashboard.mjs`: user interaction and HTTP request.
- `static/client.mjs`: browser-only cryptography.
- `static/vendor/`: unchanged pinned node-seal 4.5.6 browser library (SEAL 3.6.5) and licenses. This generated dependency is not handwritten application code.
- `app.py`, `main.cpp`, `wire.hpp`: ciphertext-only server.
- `CMakeLists.txt`, `run.sh`: build and launch.
- `setup.sh`: install pinned Microsoft SEAL 3.6.5 locally on first run.
- `test.mjs`: runtime integration and dashboard logic checks.

Requires Git, CMake 3.20+, a C++17 compiler, Python 3, and internet access for the first run. `run.sh` calls `setup.sh` when needed; the setup script downloads and builds Microsoft SEAL 3.6.5 into this project’s ignored `.deps/` folder. Later runs use that local copy. The browser dependency is already included; no npm or pip installation is needed. Tests need Node.js.

With the app running, execute `node test.mjs`. Results are saved in `test_results.json`.

## Privacy scope

The provided client sends no plaintext vectors, encoded plaintexts, secret key or decrypted answers. Public and secret keys stay in the browser; only a relinearization evaluation key is sent. The native evaluator contains no key generation or decryption code. No plaintext fallback exists.

Trust the browser code and its bundled library. Because this local server also delivers JavaScript, a malicious replacement of that code could steal inputs before encryption. This is an educational, honest-but-curious server demonstration, not a malicious-server-proof deployment or audited production service. The old WebAssembly binding requires `unsafe-eval` in the local CSP. The app binds to loopback.

Automated checks use the actual browser WASM bundle in Node and the real native server. Dashboard logic is tested with a minimal DOM harness; this is not visual browser testing.
