# 🔐 Argon2 Password Hasher CLI

A modern, high-security password hashing and verification utility built in Python using **Argon2id** (the state-of-the-art winner of the Password Hashing Competition). 

Designed with production-grade security defaults, dynamic JSON profile configuration, legacy hash re-hashing detection, and seamless cross-platform PyInstaller compilation.

---

## ✨ Features

- **Argon2id Hybrid Hashing**: Strongest defense against both GPU/ASIC brute-force attacks and side-channel cache timing attacks.
- **Config-Driven Profiles**: Fine-tune CPU (`time_cost`), memory (`memory_cost`), and concurrency (`parallelism`) via JSON.
- **Dynamic Profile Override**: Switch hashing tiers via an external `GLOBAL_CONFIG.config` override file without modifying source code.
- **Automatic Re-Hash Check**: Identifies outdated hashes when parameters are strengthened over time (`check_needs_rehash`).
- **Zero-Dependency Binary**: Standalone compilation script via PyInstaller and `Makefile` for Windows, macOS, and Linux.

---

## 📁 Repository Structure

```text
.
├── config.json            # Tuning parameters for different profiles
├── GLOBAL_CONFIG.config   # Active profile selector (e.g., 'production')
├── main.py                # Core hashing and verification CLI
├── Makefile               # Cross-platform build automation script
├── requirements.txt       # Python dependencies
└── README.md
```

---

## 🚀 Quickstart

### Prerequisites

- Python 3.9+
- `pip`

### 1. Installation

Clone the repository and install the required dependencies:

```bash
git clone https://github.com/Learnr4Namish/PasswordHasher.git
cd argon2-password-hasher

pip install -r requirements.txt
```

*(Or install the packages directly: `pip install argon2-cffi pyinstaller`)*

### 2. Run the Script

```bash
python main.py
```

Follow the interactive prompts:

```text
Active Profile: production

Welcome to my password hasher program!

Please enter your initial password: ••••••••••••
Please enter the password to verify: ••••••••••••

✅ The password is verified!
✅ Password hash saved to hashed.password.
```

---

## ⚙️ Configuration

The hashing engine is controlled by `config.json`. You can tune operational profiles to match your server's hardware capacity:

```json
{
  "version": 1.0,
  "default_profile": "production",
  "profiles": {
    "production": {
      "type": "ID",
      "time_cost": 3,
      "memory_cost": 65536,
      "parallelism": 4,
      "hash_len": 32,
      "salt_len": 16
    },
    "constrained": {
      "type": "ID",
      "time_cost": 4,
      "memory_cost": 16384,
      "parallelism": 2,
      "hash_len": 32,
      "salt_len": 16
    },
    "high_security": {
      "type": "ID",
      "time_cost": 5,
      "memory_cost": 262144,
      "parallelism": 8,
      "hash_len": 32,
      "salt_len": 16
    },
    "testing": {
      "type": "ID",
      "time_cost": 1,
      "memory_cost": 8192,
      "parallelism": 1,
      "hash_len": 16,
      "salt_len": 16
    }
  }
}
```

### Profile Switching

To change the active configuration profile without editing `config.json`, write the desired profile key into `GLOBAL_CONFIG.config`:

```bash
echo high_security > GLOBAL_CONFIG.config
```

---

## 🛠️ Building Standalone Binaries

A cross-platform `Makefile` is included to bundle the tool into a single standalone executable with all C-bindings embedded.

### Compile Executable

```bash
make
```

- **Windows**: Produces `dist\Argon2_PasswordHasher.exe`
- **Linux/macOS**: Produces `dist/Argon2_PasswordHasher`

### Clean Build Artifacts

```bash
make clean
```

---

## 🛡️ Security Parameters Guide

| Parameter | What it Does | Why it Matters |
| :--- | :--- | :--- |
| `time_cost` | Iterations over memory | Increases the CPU time required per guess, slowing down brute-force attacks. |
| `memory_cost` | RAM in KiB (e.g. `65536` = 64 MiB) | Forces attackers to dedicate real physical memory per thread, crippling GPU/ASIC parallelization. |
| `parallelism` | Number of parallel threads / lanes | Utilizes multi-core CPUs effectively on modern server architectures. |
| `hash_len` | Output length in bytes (`32` = 256 bits) | Guarantees collision resistance. |
| `salt_len` | Salt length in bytes (`16` = 128 bits) | Ensures unique hashes globally, defeating precomputed rainbow tables. |
| `type` | Argon2 variant (`ID`) | Combines data-dependent memory access (Argon2d) and data-independent memory access (Argon2i) for hybrid protection against side-channel and GPU attacks. |

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
