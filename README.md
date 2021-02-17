# rn

Repositorio del Trabajo Práctico Integrador de la cursada 2020 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Ruby Notes, o simplemente rn, es un gestor de notas concebido como un clon simplificado (convertido a un sistema web)
de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).


## Diseño general

El sistema en su totalidad está implementado en Ruby.

La aplicación consta principalmente de dos Clases (**Book** y **Note**) encargadas del manejo de los "cuadernos" 
y las "notas" 

> Todas las notas se guardan en un cuaderno. En caso de no indicar ninguno al momento de 
> crearla, se guardará por defecto en un cuaderno especial denominado "Cuaderno global (Global book)"


## Prerrequisitos para el uso de RubyNotes

Todos los comandos expuestos más adelante deben ser ejecutados en la CLI, preferentemente bash.

## Configuración del ambiente

Al no contarse con un servidor dispuesto de forma remota, deberá ser mantenido levantado en una maquina
local (por defecto este ocupará el puerto 3000). La misma debera contar con:

* Ruby (version 2.7.1).
* Pandoc, la última versión disponible (2.5 al escribir este documento).
    * Una guía de instalación del mismo está [aquí](https://pandoc.org/installing.html))
* Un gestor de paquetes de node de preferencia.
    * Es recomendado utilizar [Yarn](https://yarnpkg.com/getting-started/install)

> El sistema preferentemente deberá estar basado en UNIX, para el correcto funcionamiento de Ruby.
> Es posible la instalación en Windows, pero las instrucciones para ello escapan al alcance de este documento.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias de Ruby. El mismo se encarga de instalar 
las gemas declaradas en el archivo `Gemfile` en su versión correspondiente al ejecutar el siguiente comando:

```bash
$ bundle install
```

Esto es *requerido* para el correcto funcionamiento del sistema

> Nota: Bundler debería estar disponible en la instalación de Ruby, pero si al intentar ejecutar el comando 
> `bundle` se obtiene un error indicando que no se encuentra, es posible instalarlo mediante el siguiente comando:
> ```bash
> $ gem install bundler
> ```

Se requiere, además, proveer las dependencias de node, ejecutando:

```bash
$ yarn install
```

### Preparación de la BDD

Rails utiliza un sistema de migraciones para mantener la base de datos consistente por lo que es necesario correr 
las mismas antes de poder utilizar el sistema. Esto se logra con el comando: 

```bash
$ rails db:migrate
```

## Uso de RubyNotes

Una vez realizados los pasos anteriores, es necesario levantar el servidor y hacerlo disponible para acceder vía el navegador.
Esto es posible con el comando:

 ```bash
 $ rails server
```

Esto permitirá al usuario acceder al sistema vía la dirección web localhost:3000 o 127.0.0.1:3000.


También es posible acceder a una consola de administración del sistema (principalmente de la base de datos), 
mediante el comando:

```bash
 $ rails console
```