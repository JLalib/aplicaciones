# ============================================
# ✅ Verificación de permisos de administrador
# ============================================

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⛔ Este script requiere privilegios de administrador." -ForegroundColor Red
    Write-Host "👉 Haz clic derecho sobre el archivo y selecciona 'Ejecutar como administrador'." -ForegroundColor Yellow
    Write-Host "🛑 El script se detendrá ahora." -ForegroundColor Red
    exit 1
}

# ============================================
# ✅ Establecer política de ejecución
# ============================================

try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "🔐 Política de ejecución configurada como RemoteSigned para el usuario actual." -ForegroundColor Green
} catch {
    Write-Host "⚠️ No se pudo establecer la política de ejecución. Es posible que ya esté configurada o restringida." -ForegroundColor Yellow
}

# ============================================
# ✅ FUNCIONES DE UTILIDAD
# ============================================

function Handle-Error {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

function EstaInstalado($nombreBuscado) {
    $nombreBuscado = $nombreBuscado.ToLower()
    foreach ($path in @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )) {
        $keys = Get-ChildItem $path -ErrorAction SilentlyContinue
        foreach ($key in $keys) {
            try {
                $props = Get-ItemProperty $key.PSPath -ErrorAction SilentlyContinue
                $nombre = $props.DisplayName
                if ($nombre -and $nombre.ToLower().Contains($nombreBuscado)) {
                    Write-Host "🔍 Detectado ya instalado: $nombre"
                    return $true
                }
            } catch {}
        }
    }
    return $false
}

# ============================================
# 📦 DESCARGA Y EXTRACCIÓN DEL .7Z
# ============================================

$url = "https://github.com/JLalib/aplicaciones/releases/download/v1.0/aplicaciones.7z"
$output = "C:\aplicaciones.7z"
$outputExt = "C:\aplicaciones"

Write-Host "📥 Descargando aplicaciones.7z desde GitHub..."
try {
    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Descarga completada." -ForegroundColor Green
} catch {
    Handle-Error "No se pudo descargar el archivo desde GitHub: $url"
}

# Verificar winget y 7-Zip
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Handle-Error "winget no está disponible. Instálalo primero o usa otro método."
}

$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"
if (-not (Test-Path $sevenZipPath)) {
    Write-Host "📦 7-Zip no encontrado. Instalando..." -ForegroundColor Yellow
    try {
        winget install --id 7zip.7zip -e --source winget -ErrorAction Stop
        Write-Host "✅ 7-Zip instalado." -ForegroundColor Green
    } catch {
        Handle-Error "No se pudo instalar 7-Zip."
    }
}

if (-not (Test-Path $sevenZipPath)) {
    Handle-Error "7-Zip no está instalado correctamente."
}

# Crear carpeta si no existe
if (-not (Test-Path $outputExt)) {
    New-Item -Path $outputExt -ItemType Directory | Out-Null
}

Write-Host "🧩 Extrayendo en $outputExt..."
&"$sevenZipPath" x $output -o"$outputExt" -y
Write-Host "✅ Extracción completada." -ForegroundColor Green

Remove-Item $output -Force
Write-Host "🗑️ Archivo aplicaciones.7z eliminado." -ForegroundColor Green

# ============================================
# 🚀 INSTALACIÓN DE APLICACIONES
# ============================================

Set-Location -Path "C:\aplicaciones"

# Leer equivalencias
$equivalencias = @{}
$equivalenciasTxt = "C:\aplicaciones\equivalencias.txt"
if (Test-Path $equivalenciasTxt) {
    Get-Content $equivalenciasTxt | ForEach-Object {
        if ($_ -match "^\s*([^=]+?)\s*=\s*(.+?)\s*$") {
            $clave = $matches[1].Trim()
            $valor = $matches[2].Trim()
            $equivalencias[$clave] = $valor
        }
    }
    Write-Host "🗂️ Equivalencias cargadas desde equivalencias.txt"
} else {
    Write-Host "⚠️ No se encontró equivalencias.txt en C:\aplicaciones. Se instalarán todos los archivos sin comprobación."
}

# Buscar instaladores
$instaladores = Get-ChildItem -Path "." -Filter *.exe -File
$instaladores += Get-ChildItem -Path "." -Filter *.msi -File

if ($instaladores.Count -eq 0) {
    Write-Host "❌ No se encontraron instaladores en C:\aplicaciones"
    exit
}

foreach ($archivo in $instaladores) {
    $nombreArchivo = [System.IO.Path]::GetFileNameWithoutExtension($archivo.Name)
    $ruta = $archivo.FullName

    if ($equivalencias.ContainsKey($nombreArchivo)) {
        $nombreReal = $equivalencias[$nombreArchivo]
        if (EstaInstalado $nombreReal) {
            Write-Host "✅ $($archivo.Name) ya está instalado como '$nombreReal'. Se omite."
            continue
        }
    } else {
        Write-Host "ℹ️ No hay equivalencia para '$nombreArchivo'. Se instalará sin comprobar."
    }

    Write-Host "`n🚀 Ejecutando instalador: $($archivo.Name)"
    Start-Process -FilePath $ruta -Wait
}

Write-Host "`n✅ Instalación completada." -ForegroundColor Green
