#!/bin/bash
# Script para la creacion del archivo README principal
function generar_seccion {
    categoria=${1}
    contenido="### ${categoria}\n\n| Laboratorios |\n|-----|"
    AUX_IFS="${IFS}"
    IFS=$'\n'
    labs=( $(find "${categoria}" -type f -iname "README.md" | sort -r | xargs grep "Lab" ) )
    for i in $( seq 0 $(("${#labs[@]}"-1)) ) ; do
        ruta=$(echo ${labs[${i}]} | grep -o -P "^[^:]*" )  
        numero=$(echo ${labs[${i}]} | grep -o -P "/\Klab[^/]*")
        nombre=$(echo ${labs[${i}]} | grep -o -P "# Lab: \K.*")
        contenido="${contenido}\n| [${numero} - ${nombre}](${ruta}) |"    
    done
    contenido="${contenido}""\n\n---"
    echo -e "${contenido}"
    IFS="${AUX_IFS}"
}
function generar_readme {
    cont="# PortSwigger Web Security Academy Write-ups\n"
    cont="${cont}""Repositorio con mis write-ups de los laboratorios de PortSwigger Web Security Academy.\n"
    cont="${cont}""## Contenido\n"
    categorias=( "sql-injection" "access-control-vulnerabilities" "os-command-injection" "file-upload" )
    for categoria in "${categorias[@]}" ; do
        secc=$(generar_seccion "${categoria}")
        cont="${cont}\n\n${secc}"
    done
    echo -e "${cont}"
}


generar_readme


#generar_seccion "sql-injection"b
