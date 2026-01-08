# Scripts Útiles

Colección de scripts personalizados para automatizar tareas comunes.

## Estructura

```
scripts/
├── backup.sh          # Script de respaldo
├── restore.sh         # Script de restauración
├── install.sh         # Script de instalación inicial
└── update.sh          # Script de actualización
```

## Scripts sugeridos

### backup.sh
Respalda todos los dotfiles desde sus ubicaciones originales a este repositorio.

### restore.sh
Restaura los dotfiles desde este repositorio a sus ubicaciones originales.

### install.sh
Script de instalación inicial para un sistema nuevo.

### update.sh
Actualiza paquetes y plugins (Mason, LazyVim, etc.)

## Uso

```bash
# Hacer ejecutables
chmod +x scripts/*.sh

# Ejecutar
./scripts/backup.sh
./scripts/restore.sh
```
