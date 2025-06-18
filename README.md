# 📦 Instalador Automático de Aplicaciones

Este repositorio contiene un instalador automatizado para desplegar múltiples aplicaciones en equipos Windows. El script descarga un paquete comprimido `.7z` desde GitHub Releases, lo extrae en `C:\aplicaciones`, y ejecuta todos los instaladores incluidos (`.exe` y `.msi`), evitando reinstalaciones innecesarias mediante un archivo `equivalencias.txt`.

---

## 📁 Contenido del Repositorio

- `automated apps download and install v1.ps1`: Script PowerShell principal
- `launch PS.bat`: Lanzador automático que ejecuta el script `.ps1` con privilegios de administrador
- `aplicaciones.7z`: Archivo comprimido disponible en [Releases](https://github.com/JLalib/aplicaciones/releases)

---

## 🧩 ¿Qué hace?

1. **Descarga** `aplicaciones.7z` desde GitHub Releases
2. **Extrae** su contenido en `C:\aplicaciones`
3. **Lee** `equivalencias.txt` (si está presente)
4. **Verifica** si las aplicaciones ya están instaladas
5. **Ejecuta** los instaladores necesarios
6. **Elimina** el archivo `.7z` tras la extracción

---

## 📝 Formato del archivo `equivalencias.txt`

Cada línea define el nombre del archivo instalador (sin extensión) y el nombre del programa tal como aparece en el sistema:

Ejemplo:

vlc = VLC media player

chrome = Google Chrome

adobe = Adobe Acrobat Reader


> ⚠️ El nombre del archivo (sin extensión) debe coincidir con el de la izquierda. Esto permite evitar instalar software ya presente en el equipo.

---

## 🚀 ¿Cómo se ejecuta?

### ✅ Opción 1: Doble clic (recomendado)

1. Haz doble clic en `launch PS.bat`
2. El script PowerShell se abrirá automáticamente **con permisos de administrador**

### ⚙️ Opción 2: Manual (PowerShell)

1. Haz clic derecho en `automated apps download and install v1.ps1`  
   → Selecciona **"Ejecutar con PowerShell como administrador"**

O bien:

```powershell
powershell -ExecutionPolicy Bypass -File "automated apps download and install v1.ps1"

