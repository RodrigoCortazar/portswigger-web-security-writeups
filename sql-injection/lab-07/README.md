# Lab: SQL injection UNION attack, determining the number of columns returned by the query

## Objetivo
Determinar el numero de columnas que estan siendo devueltas por la consulta

## Información dada

* Vulnerabilidad sql injection en el filtro de categoria de productos.



## Exploración

La pagina cuenta con una serie de enlaces que recargan la pagina para mostrar los productos de la categoria seleccionada. Dichos enlaces realizan una peticion al endpoint `filter` usando el parametro `category`



![Exploracion](screenshots/exploracion.png)

---


## Explotacion

La aplicación acepto la inyeccion de la forma `'--`, por lo que se descarto que el motor de bdd usado fuera MySQL

![comentario](screenshots/comentario.png)

Para determinar la cantidas de columnas tomadas en la consulta, se inyecto `'+ORDER+BY+N--` , y se incremento `N`, hasta que hubo un cambio en el comportamiento de la pagina. Se determino que fueron 3 columnas.

![orderby](screenshots/orderby.png)

La aplicación acepto la inyeccion de la forma `'+UNION+SELECT+34,'A',11--`, por lo que se descarto que el motor de BDD utilizado fuera Oracle, ya que en Oracle todas las sentencias SELECT requieren la cláusula FROM.


![union](screenshots/union.png)







