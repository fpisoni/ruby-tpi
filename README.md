# rn

Repositorio del Trabajo Práctico Integrador de la cursada 2020 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Ruby Notes, o simplemente `rn`, es un gestor de notas concebido como un clon simplificado
de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).


## Diseño general

El sistema en su totalidad está implementado en Ruby.

La aplicación consta principalmente de dos Clases (**Book** y **Note**) encargadas del 
manejo de los "cuadernos" (carpetas en el sistema) y las "notas" (archivos de texto plano 
dentro de los cuadernos).

> Todas las notas se guardan en un cuaderno. En caso de no indicar ninguno al momento de 
> crearla, se guardará por defecto en un cuaderno especial denominado "Cuaderno global"

Las mismas tienen tres módulos asistentes que proveen de diversas utilidades:

   * *Paths*, encargado del manejo de las direcciones de los archivos del sistema, así como 
   del chequeo de nombres
   * *File_Utils*, encargado de las acciones efectivas sobre los archivos y las carpetas
   * *Errors*, encargado de estandarizar los errores e informarlos al usuarix.


## Uso de `rn`

### Configuración

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual
puede correrse de las siguientes manera:

```bash
$ ruby bin/rn [args]
```

O bien:

```bash
$ bundle exec bin/rn [args]
```

O simplemente:

```bash
$ bin/rn [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicadx en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ rn [args]
```

(esta forma será la utilizada para explicar el uso básico de RN)

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.5 o posterior, preferentemente 2.7.2) y tener instaladas sus dependencias, las cuales 
> se manejan con Bundler. Para más información sobre la instalación de las dependencias, consultar 
> la sección Desarrollo.

### Comandos

#### Books

Los cuadernos cuentan con cuatro funcionalidades:

   1. **Creación**

   ```bash
    rn books create BOOK 
   ```

   Crea el cuaderno BOOK

   2. **Eliminación**

   ```bash
    rn books create BOOK "[--global]"
   ```

   Elimina el cuaderno BOOK y **todas** sus notas

   > El comando acepta el parámetro ` --global `, lo cual **ignora** el nombre otorgado y 
   > **vacía** el cuaderno global.

   3. **Listado**

   ```bash
    rn books list
   ```

  Lista todos los cuadernos y cuántas notas tiene cada uno

   4. **Renombrado**

   ```bash
    rn books rename BOOK NEW_NAME
   ```

  Renombra el cuaderno BOOK a NEW_NAME

#### Notas

Las notas cuentan con seis funcionalidades:

   1. **Creacion**

   ```bash
    rn notes create NOTE CONTENT "[--book BOOK]"
   ```

  Crea la nota NOTE con el contenido CONTENT.
   
  > En caso de proporcionarse el argumento opcional `--book`, se guarda en el cuaderno BOOK.

   2. **Eliminación**

   ```bash
    rn notes delete NOTE "[--book BOOK]"
   ```

   Elimina la nota NOTE.
  
  > En caso de proporcionarse el argumento opcional `--book`, se buscará en el cuaderno BOOK.
  > De no hacerlo, se la buscará en el Cuaderno global.

   3. **Listado**

   ```bash
    rn notes list "[--global --book BOOK]"
   ```

   Lista notas. Por defecto, listará todas las notas existentes.

  > En caso de recibir el argumento `--book`, se listará solo las existentes en el cuaderno BOOK. 
  > Si se proporciona el argumento `--global`, casuará que se **ignore** el parámetro 
  > `--book` y se liste el cuaderno global.

   4. **Edición**

   ```bash
    rn notes edit NOTE "[--book BOOK]"
   ```

   Abre el editor definido en $EDITOR para modificar el contenido de NOTE

  > En caso de recibir el argumento `--book`, se buscará en el cuaderno BOOK (en el global en su ausencia)

   5. **Renombrado**

   ```bash
    rn notes retitle NOTE NEW_NAME "[--book BOOK]"
   ```

  Cambia el nombre de NOTE a NEW_NAME

  > En caso de recibir el argumento `--book`, se buscará en el cuaderno BOOK (en el global en su ausencia)

   6. **Mostrado**

   ```bash
    rn notes show NOTE "[--book BOOK]"
   ```

   Muestra el contenido de la nota NOTE

  > En caso de recibir el argumento `--book`, se buscará en el cuaderno BOOK (en el global en su ausencia)


## Desarrollo

Esta sección provee algunos tips para la extensión del proyecto.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```
