# Venered Social

Una red social moderna tipo Instagram/Threads, hecha en Flutter, lista para producción y web.

## Características principales
- Feed con animaciones y stories
- Perfil editable, seguidores/seguidos, publicaciones editables/eliminables
- Mensajería directa
- Búsqueda avanzada de usuarios y posts
- Notificaciones en tiempo real (simuladas)
- Verificación de cuentas
- Accesibilidad y adaptabilidad (a11y, dark/light)
- Pruebas automáticas incluidas

## Instalación y ejecución

1. Instala Flutter 3.x+
2. Ejecuta:
   ```
   flutter pub get
   flutter run -d chrome
   ```
3. Para web, también puedes compilar y servir:
   ```
   flutter build web
   python3 -m http.server 8090 --directory build/web
   ```

## Pruebas

```
flutter test
```

## Estructura
- `lib/main.dart`: Código principal de la app
- `test/app_test.dart`: Pruebas automáticas
- `web/`: Archivos para web

## Créditos
Desarrollado por SoyJuanPiece y GitHub Copilot.