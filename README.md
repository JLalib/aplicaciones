# 📦 Instalador Automático de Aplicaciones

Este repositorio contiene un instalador automatizado para desplegar múltiples aplicaciones en equipos Windows. El script descarga un paquete comprimido `.7z` desde GitHub Releases, lo extrae en `C:\aplicaciones`, y ejecuta todos los instaladores incluidos (archivos `.exe` y `.msi`), evitando reinstalaciones innecesarias.

---

## 🚀 ¿Qué incluye?

- 📁 `aplicaciones.7z` (en Releases):
  - Instaladores `.exe` / `.msi`
  - Archivo `equivalencias.txt` con nombres amigables para verificación
- 📜 Script PowerShell `instalador.ps1`

---

## 🧩 Cómo funciona

1. **Descarga** `aplicaciones.7z` desde [Releases](https://github.com/JLalib/aplicaciones/releases)
2. **Extrae** automáticamente en `C:\aplicaciones`
3. **Lee** `equivalencias.txt` (si existe)
4. **Verifica** si ya están instaladas las apps
5. **Ejecuta** los instaladores necesarios
6. **Elimina** el archivo `.7z` al final

---

## 📝 Archivo `equivalencias.txt`

Este archivo permite asociar nombres de archivo con el nombre real del programa instalado (según lo que aparece en Panel de Control).

Ejemplo:

vlc = VLC media player

chrome = Google Chrome

adobe = Adobe Acrobat Reader


> ⚠️ El nombre del archivo (sin extensión) debe coincidir con el de la izquierda.

---

## 🖥️ Ejecución del Script

1. Haz clic derecho sobre `automated apps download and install v1.ps1`
2. Ejecuta como **Administrador**

O desde consola:

```powershell
powershell -ExecutionPolicy Bypass -File instalador.ps1
