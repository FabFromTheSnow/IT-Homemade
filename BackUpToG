import os

folder_path = r'E:\Clienti\'
destination_folder = r' G:\.shortcut-targets-by-id\1nnSc9jfcOXIBEzc_bzhbXx_taTvCJ6NQ\Clienti'
files = os.listdir(folder_path)

for root, directories, files in os.walk(folder_path):
    for file_name in files:
        file_path = os.path.join(root, file_name)
        relative_root = os.path.relpath(root, folder_path)
        destination_path = os.path.join(destination_folder, relative_root)
        os.makedirs(destination_path, exist_ok=True)
        print(file_path)
        os.system(f"copy \"{file_path}\" \"{destination_path}\"")

folder_path2 = r'D:\DATI\LBS\Amministrazione\'
destination_folder2 = r'G:\.shortcut-targets-by-id\1ZfQs41p5aaOpiyU3KbVtwvnlBzy-Akqg\Amministrazione'
files2 = os.listdir(folder_path2)

for root, directories, files in os.walk(folder_path2):
    for file_name in files:
        file_path = os.path.join(root, file_name)
        relative_root = os.path.relpath(root, folder_path2)
        destination_path = os.path.join(destination_folder, relative_root)
        os.makedirs(destination_path, exist_ok=True)
        print(file_path)
        os.system(f"copy \"{file_path}\" \"{destination_path}\"")
