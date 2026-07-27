# Lab: Unprotected admin functionality with unpredictable URL

## Objetivo

Eliminar al usuario carlos

## Información dada

* Panel administrativo desprotegido en un ubicacion no predecible
* Ubicacion revelada en algun lugar de la respuesta


## Reconocimiento

EL sitio disponia de una pagina de inicio de sesion

![Exploracion](screenshots/exploracion.png)

Se realizo la busqueda de elementos que pudieran estar relacionados con el panel administrativo. Mediante dicha busqueda se logro encontrar la pagina de `/admin-5vbmg6` 

![busqueda](screenshots/busqueda.png)


---



## Explotacion

El acceso a la pagina de `/admin-5vbmg6` no solicito ningun metodo de autenticacion , lo que permitio utilizar la funcionalidad para la eliminación de usuarios 

![explotacion](screenshots/explotacion.png)

