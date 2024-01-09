import os
import requests
import json
from pathlib import Path
import scan
import directories

# Gets app info based on id found using check_local_directories, and then jsonify the data
def get_app_info(app_id):
    url = f'http://api.steampowered.com/ISteamApps/GetAppList/v2/' 
    
    try:
        response = requests.get(url)
        data = response.json()

        if 'applist' in data and 'apps' in data['applist']: 
            apps = data['applist']['apps']
            for app in apps:
                if app['appid'] == app_id:
                    app_info = {
                        'appid': app_id,
                        'name': app['name'],
                        'directory': None, # Don't have this info yet, so set it to None.
                        'image_link': f'http://cdn.akamai.steamstatic.com/steam/apps/{app_id}/header.jpg' # This works, but it gives you a header, which is a wide image,
                    }                                                                                     # a Cover image would be more suitable for the app.
                    return app_info

        print(f"Error: Unable to find information for App ID {app_id}.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None


# Checks provided list paths for subdirectories with an id as a name
def check_local_directories(base_paths):
    result_data = {'applist': {'apps': []}}

    for base_path in base_paths:
        for subdir in os.listdir(base_path):
            subdir_path = os.path.join(base_path, subdir)
            if os.path.isdir(subdir_path):
                try:
                    app_id_from_name = scan.get_app_id_from_name( subdir)
                    app_id_from_subdir = int(subdir) if subdir.isdigit() else None

                    if app_id_from_subdir is not None:
                        app_id = app_id_from_subdir
                        app_name = scan.get_app_name_from_id(app_id_from_subdir)
                    elif app_id_from_name is not None:
                        app_id = app_id_from_name
                        app_name = subdir
                    else:
                        raise ValueError("Both app ID from name and subdirectory are invalid.")

                    app_info = {
                        'appid': app_id,
                        'name': app_name,
                        'directory': subdir_path,
                        'image_link': f'http://cdn.akamai.steamstatic.com/steam/apps/{app_id}/header.jpg'
                    }
                    result_data['applist']['apps'].append(app_info)
                    print(f"App ID: {app_id}, App Name: {app_name}, Directory: {subdir_path}")
                except ValueError as e:
                    print(f"Skipping subdirectory: {subdir}, {e}")

    return result_data

save_path = str(Path.home() / 'Documents')

# Pretty self-explanatory, saves data in a json file
def save_to_json(data, filename= os.path.join(save_path, 'steam_app_info.json') ):
    with open(filename, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

def main():
 
    

    result_data = check_local_directories(directories.user_data_paths)
    save_to_json(result_data) 

if __name__ == "__main__":
    main()
