import os
from os import listdir
from os.path import isfile, join
import requests
import json
from pathlib import Path

# Returns app id by matching the app_name in database
def get_app_id_from_name(app_name):
    url = f'http://api.steampowered.com/ISteamApps/GetAppList/v2/'

    try:
        response = requests.get(url)
        data = response.json()

        if 'applist' in data and 'apps' in data['applist']:
            apps = data['applist']['apps']
            for app in apps:
                if app['name'] == app_name:
                    return app['appid']        
        
    except Exception as e:
        print(f"Error: {e}")
        return None

# Returns app name by matching id with ids in database
def get_app_name_from_id( app_id):
    url = f'http://api.steampowered.com/ISteamApps/GetAppList/v2/'

    try:
        response = requests.get(url)
        data = response.json()

        if 'applist' in data and 'apps' in data['applist']:
            apps = data['applist']['apps']
            for app in apps:
                if app['appid'] == app_id:
                    return app['name']

        print(f"Error: Unable to find information for App ID: {app_id}.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None




subDirs = listdir("C:\\Program Files (x86)\\Steam\\userdata\\")
print(subDirs)
userID = subDirs[0]
print(userID)


