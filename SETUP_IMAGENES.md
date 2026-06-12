# Guía de Implementación: Manejo de URLs de Imágenes

## ✅ Cambios Realizados

### 1. **Carpeta `uploads/` creada**
- Ubicación: `c:/xampp/htdocs/APPPROYECTOSENA/uploads/`
- Propósito: Almacenar imágenes de productos locales

### 2. **API Backend Actualizada**

#### `productos/listar.php` (MODIFICADO)
- ✅ Ahora construye URLs completas automáticamente
- ✅ Detecta si es URL local o externa
- ✅ Convierte nombres de archivo → URLs completas
- Ejemplo: `nike-air-max.jpg` → `http://192.168.40.49/APPPROYECTOSENA/uploads/nike-air-max.jpg`

#### `productos/crear.php` (MEJORADO)
- ✅ Acepta nombres de archivo (para almacenamiento local)
- ✅ Acepta URLs externas completas
- ✅ Mejor mensaje de respuesta

#### `productos/actualizar.php` (MEJORADO)
- ✅ Mismo comportamiento que crear.php
- ✅ Código más limpio

### 3. **Archivos de Documentación Creados**
- `uploads/README.md` - Instrucciones de uso
- `productos/actualizar-imagenes.sql` - Script SQL para actualizar BD
- `productos/test-urls.php` - Endpoint de prueba/diagnóstico

---

## 🚀 Cómo Usar

### Opción A: Imágenes Locales (Recomendado)

1. **Coloca imagen en**: `c:/xampp/htdocs/APPPROYECTOSENA/uploads/`
   - Ejemplo: `nike-air-max.jpg`

2. **En la app Flutter, al crear producto**:
   - Campo Imagen: `nike-air-max.jpg` (solo el nombre)
   - ✅ El API la convertirá automáticamente a URL completa

### Opción B: URLs Externas

1. **En la app Flutter, al crear producto**:
   - Campo Imagen: `https://example.com/nike-air-max.jpg`
   - ✅ El API la usará tal cual

---

## 🔍 Cómo Verificar

### Test 1: Acceder a endpoint de prueba
```
http://192.168.40.49/APPPROYECTOSENA/productos/test-urls.php
```

Verás un JSON con:
- `imagen_original`: Lo guardado en BD
- `imagen_completa`: La URL final que usa Flutter
- `tipo`: "local" o "externa"

### Test 2: Probar en Flutter
1. Abre ProductosScreen
2. Las imágenes con URLs válidas cargarán
3. Las imágenes inválidas mostrarán el ícono fallback (balón)

### Test 3: Crear producto con imagen local
1. Abre ProductoFormScreen
2. En campo "URL de la imagen" escribe: `nike-air-max.jpg`
3. Guarda → Verifica en ProductosScreen

---

## 📋 Requisitos Para Nike Air Max

Para que cargue correctamente la Nike Air Max:

```
1. Archivo de imagen debe existir en:
   c:/xampp/htdocs/APPPROYECTOSENA/uploads/nike-air-max.jpg

2. En la BD, el producto debe tener:
   imagen = "nike-air-max.jpg"  (SOLO nombre del archivo)

3. O usar URL externa:
   imagen = "https://example.com/nike-air-max.jpg"
```

---

## 🐛 Si la imagen no carga:

1. **Verifica el endpoint test**:
   ```
   GET http://192.168.40.49/APPPROYECTOSENA/productos/test-urls.php
   ```

2. **Comprueba que el archivo existe**:
   ```
   c:/xampp/htdocs/APPPROYECTOSENA/uploads/nike-air-max.jpg
   ```

3. **Revisa el campo `imagen_completa`** en el test
   - Debe ser una URL válida y accesible

4. **Si aún falla**:
   - El ícono fallback (balón gris) se mostrará
   - Revisa la consola de Flutter para errores de red

---

## 📝 Script SQL de Ejemplo

Ejecuta en phpMyAdmin para actualizar productos existentes:

```sql
-- Actualizar Nike Air Max
UPDATE productos
SET imagen = 'nike-air-max.jpg'
WHERE nombre LIKE '%Nike Air Max%';

-- Ver todos los productos
SELECT id, nombre, imagen FROM productos;
```

Ubicación del archivo: `productos/actualizar-imagenes.sql`
