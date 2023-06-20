import os
import zipfile
import shutil
import datetime



folder_path = "C:\\Users\\" 
log = "\\AppData\Roaming\\Language Business Solutions"
save = "C:\\Users\\mestf\Desktop\\backup\\"

subdirectories = [name for name in os.listdir(folder_path) if os.path.isdir(os.path.join(folder_path, name))]  #get users

for subfolder in subdirectories:
    logfolder = folder_path + subfolder + log #construct log path 
    current_date = datetime.datetime.now().strftime("%d%m%Y")
    output = save + subfolder + "_LBS_" + current_date
    if os.path.exists(logfolder):
        shutil.make_archive(output, 'zip', logfolder)
