# ButanoDeath - Addon para WoW

Este addon reproduce un archivo de sonido personalizado cada vez que tu personaje muere.

---

## 📁 Estructura del Addon

La carpeta del addon debe llamarse exactamente **`ButanoDeath`** y colocarse en:

```text
World of Warcraft/
└── Interface/
    └── AddOns/
        └── ButanoDeath/
            ├── ButanoDeath.toc
            ├── Core.lua
            └── sounds/
                └── death.mp3   <-- (Tu archivo de audio aquí)
```

---

## 🎵 Requisitos del Audio

1. Guarda tu audio con el nombre **`death.mp3`** (o `.ogg`) dentro de la carpeta `sounds/`.
2. **¡Importante!**: El cliente de World of Warcraft indexa archivos de sonido nuevos **únicamente al iniciar el juego**. Si agregas el audio con el juego abierto, reinícialo.

---

## 🧪 Comandos de prueba

En el chat del juego puedes probar el audio escribiendo cualquiera de estos:
- `/bd`
- `/butano`
- `/butanodeath`
