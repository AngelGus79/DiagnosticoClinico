# Diagnóstico clínico

Herramienta que realiza un diagnóstico clínico a partir de unas preguntas.

Esta herramienta utiliza el lenguaje funcional [ELM][elm installer] en su versión 1.8.

Los paquetes utilizados en "Diagnóstico clínico" son los siguientes:

| Usuario | Paquete | Version |
| ------ | ------ | -
| NoRedInk | [elm-decode-pipeline] [nri Pipeline] | 3.0.0|
| debois | [elm-mdl] [debois mdl] | 8.1.0|
| elm-lang | [core] [elm core] | 5.1.1|
| elm-lang | [html] [elm html] | 2.0.0|
| elm-lang | [http] [elm http] | 1.0.0|

Para instalar y hacer uso de esta aplicación siga los siguientes pasos:

1. Instalar [ELM][elm installer] (recuerda instalar la versión 1.8).
2. Descargar esta aplicación con el comando:
```sh
$ git clone https://github.com/AngelGus79/DiagnosticoClinico
```
3. Instalar los paquetes
```sh
$ cd DiagnosticoClinico
$ elm-package install
```
4. Iniciar elm reactor.
```sh
$ elm reactor
```
5. Por último iniciar la aplicación en tu [navegador] [app init].

   [elm installer]: <http://elm-lang.org:1234/install>
   [nri Pipeline]: <https://github.com/NoRedInk/elm-decode-pipeline>
   [debois mdl]: <https://github.com/debois/elm-mdl>
   [elm core]: <https://github.com/elm-lang/core>
   [elm html]: <https://github.com/elm-lang/html>
   [elm http]: <https://github.com/elm-lang/http>
   [app init]: <http://localhost:8000/Update.elm>
