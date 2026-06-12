# Carpeta de Imágenes de Productos

Esta carpeta almacena las imágenes de los productos de la tienda de tenis.

## Cómo usar:

### 1. Colocar imágenes aquí
Guarda archivos de imagen con extensiones: `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`

**Ejemplo**: `nike-air-max.jpg`

### 2. Referenciar en la base de datos
Al crear o editar un producto, en el campo `imagen` coloca solo el **nombre del archivo**:

```
nike-air-max.jpg
```

**NO coloque la ruta completa**, el API la construirá automáticamente.

### 3. URLs completas (construcción automática)
El endpoint `listar.php` convierte automáticamente:

```
nike-air-max.jpg
↓
http://192.168.40.49/APPPROYECTOSENA/uploads/nike-air-max.jpg
```

### 4. Alternativa: URLs externas
Si quieres usar imágenes de internet, también puedes usar URLs completas:

```
https://example.com/imagen-externa.jpg
```

El API las detecta y las deja tal cual.

## Estructura esperada

```
APPPROYECTOSENA/
├── uploads/
│   ├── nike-air-max.jpg
│   ├── nike-blazer.png
│   ├── adidas-ultra-boost.jpg
│   └── README.md (este archivo)
├── productos/
│   ├── listar.php
│   ├── crear.php
│   └── ...
```

## Permisos

Asegúrate de que la carpeta `uploads/` tiene permisos de lectura (755 recomendado):

```bash
chmod 755 uploads/
```
