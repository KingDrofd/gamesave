import os
import requests
import json

# Gets app info based on id found using check_local_directories, and then jsonify the data
def get_app_info( app_id):
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


#TODO Check directories using names and then geting their ids from name 
#(some games save in other directories without ids and use the name instead, ie. Bioshock, Anno1800)


# Checks provided list paths for subdirectories with an id as a name
def check_local_directories( base_paths):
    result_data = {'applist': {'apps': []}}

    for base_path in base_paths:
        for subdir in os.listdir(base_path):
            subdir_path = os.path.join(base_path, subdir)
            if os.path.isdir(subdir_path):
                try:
                    app_id = int(subdir)
                    app_info = get_app_info( app_id)
                    if app_info:
                        app_info['directory'] = subdir_path # We update directory information here.
                        result_data['applist']['apps'].append(app_info)
                        print(f"App ID: {app_id}, App Name: {app_info['name']}, Directory: {subdir_path}")
                    else:
                        print(f"Unable to retrieve information for App ID: {app_id}")
                except ValueError:
                    print(f"Skipping non-numeric directory: {subdir}")

    return result_data

# Pretty self-explanatory, saves data in a json file
def save_to_json(data, filename='steam_app_info.json'):
    with open(filename, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

def main():
 
    user_data_paths = [
        r'C:\Program Files (x86)\Steam\userdata\443815666',
        # Other paths here
    ]

    result_data = check_local_directories(user_data_paths)
    save_to_json(result_data) 

if __name__ == "__main__":
    main()
