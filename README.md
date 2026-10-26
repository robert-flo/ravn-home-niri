# ravn-home-niri

Capa de escritorio Wayland bajo **Niri** y **Clavis Shell (Quickshell)** para la estación de trabajo Arch / Omarchy de la familia ravn.

Forma parte del piloto de `$HOME` por capas (spec madre `PJ-NIRI-rf-omarchy-workstation#17`, spec padre `#40`, issue `#43`). Se distribuye empaquetado como `ravn-home-niri` vía pacman en `/usr/share/ravn/niri`.

---

## 🏛️ Arquitectura de Carga en Niri

A diferencia de entornos que requieren symlinks para su configuración principal, **Niri soporta la inclusión nativa de archivos KDL** mediante directivas `include`.

### 1. Inclusión desde el Perfil de Usuario (`~/.config/niri/config.kdl`)

El repositorio de perfil del usuario solo requiere un archivo cargador mínimo:

```kdl
// ~/.config/niri/config.kdl
// Carga la configuración central inmutable del paquete pacman:
include "/usr/share/ravn/niri/niri/config.kdl"

// Sobrescrituras específicas de la máquina (monitores, modos, escalas):
include optional=true "outputs.kdl"
```

Los includes relativos definidos dentro de `/usr/share/ravn/niri/niri/config.kdl` (como `include "clavis/binds.kdl";` o `include "liquidbird.kdl";`) se resuelven automáticamente de forma relativa al archivo importado en `/usr/share/ravn/niri/niri/`.

### 2. Exclusión de `outputs.kdl`

La configuración de salidas físicas y pantallas (`outputs.kdl`) es de **ámbito de máquina** (varía según monitor, display HDMI/eDP y resolución de hardware). Queda estrictamente excluida del repositorio y del paquete (`.gitignore`). Niri incluye `outputs.kdl` con `optional=true`, por lo que su ausencia en `/usr/share/ravn/niri/` es tolerada de forma segura.

---

## 📂 Estructura del Repositorio y del Paquete

Instalado en `/usr/share/ravn/niri/`:

```
/usr/share/ravn/niri/
├── bin/
│   ├── clavis-mpvpaper.sh             # Gestor de fondos de pantalla en video
│   ├── optimize-wallpaper             # Conversión 1080p@30fps VA-API / CPU
│   ├── niri-dotfiles-postinstall      # Postinstalación idempotente adaptada
│   ├── ravn-niri-postinstall          # Enlace simbólico a niri-dotfiles-postinstall
│   └── ravn-niri-sync                 # Sincronizador de perfil de usuario
├── clavis/
│   ├── config.json                    # Configuración declarativa de Clavis
│   └── matugen/
│       └── config.toml                # Templates de colores dinámicos
├── environment.d/
│   └── clavis-mpvpaper.conf           # Variables de entorno XDG de sesión
├── niri/
│   ├── config.kdl                     # Configuración principal de Niri
│   ├── liquidbird.kdl                 # Reglas de estilo para Thunderbird
│   ├── obsidian-violet.kdl            # Reglas de estilo y blur para Obsidian
│   ├── statindet-animations.kdl       # Animaciones fluidas
│   ├── statindet-colors.kdl           # Anillo de foco y colores base
│   ├── statindet-windowrule.kdl       # Esquinas redondeadas universales
│   └── clavis/
│       ├── binds.kdl                  # Atajos de teclado gestionados por Clavis
│       ├── cursor.kdl                 # Cursor y tamaño MacTahoe
│       ├── effects.kdl                # Efectos X-Ray
│       ├── hot-corners.kdl            # Comportamiento de esquinas
│       ├── layer-rules.kdl            # Reglas de capas para overview y fondos
│       └── minimize-animation.kdl     # Efecto genie de minimizado
└── share/
    ├── clavis/
    │   └── wallpapers/
    │       ├── statindet/
    │       │   └── wallhaven-rq6yqm.jpg
    │       ├── wallhaven-5y3571.jpg
    │       └── video/
    │           ├── optimize-wallpaper.sh
    │           └── README.md
    └── statindet-niri/
        └── niri-colors.kdl
```

---

## ⚙️ Postinstalación Idempotente (`niri-dotfiles-postinstall`)

El script `niri-dotfiles-postinstall` ha sido adaptado para operar sin asunciones rígidas de usuario:
1. No falla al encontrar archivos o enlaces de solo lectura en `/usr/share/ravn/`.
2. Resuelve rutas relativas y variables `$HOME` dinámicamente.
3. Configura esquemas gsettings (GTK theme, Icon theme, Cursors) cuando existe bus D-Bus disponible.
4. Habilita de forma segura servicios de usuario systemd (`clavis-shell.service`, `clavis-clipboard.service`).
5. Genera la paleta dinámica con Matugen desde el fondo activo.
6. Valida la sintaxis del compositor ejecutando `niri validate`.

---

## 🧪 Pruebas Locales

Ejecutar la suite de pruebas:

```bash
make test
```
