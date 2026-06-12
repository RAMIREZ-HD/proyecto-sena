-- Script para actualizar URLs de imágenes en la base de datos
-- Ejecutar en phpMyAdmin o desde el CLI de MySQL

-- Ejemplo: Si tienes productos con nombres de archivo, actualiza así:

-- Para Nike Air Max (si existe)
UPDATE productos
SET imagen = 'nike-air-max.jpg'
WHERE nombre LIKE '%Nike Air Max%' OR marca LIKE '%Nike%';

-- Para productos sin imagen válida, asigna un nombre de archivo
UPDATE productos
SET imagen = 'producto-generico.jpg'
WHERE imagen IS NULL OR imagen = '' OR imagen = 'null';

-- Para ver los productos actuales y sus imágenes
SELECT id, nombre, marca, imagen FROM productos;

-- Notas importantes:
-- 1. Los archivos deben existir en c:\xampp\htdocs\APPPROYECTOSENA\uploads\
-- 2. Coloca solo el nombre del archivo, NO la ruta completa
-- 3. El API construirá automáticamente: http://192.168.40.49/APPPROYECTOSENA/uploads/{imagen}
-- 4. También acepta URLs externas completas (http://...)

-- Ejemplo de producto con URL externa:
UPDATE productos
SET imagen = 'https://example.com/nike-air-max.jpg'
WHERE id = 1;
