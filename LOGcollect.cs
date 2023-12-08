using System;
using System.IO;
using System.IO.Compression;

class Program
{
    static void Main()
    {
        string baseFolderPath = @"C:\Users\"; // Base folder path
        Console.WriteLine(string.Format("Scanning base directory: {0}", baseFolderPath));

        string subFolderPath = @"\AppData\Roaming\Language Business Solutions"; // Subfolder to zip
        string backupFolderPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + @"\backup\"; // Backup folder path
        Console.WriteLine(string.Format("Backups will be saved to: {0}", backupFolderPath));

        // Ensure the backup directory exists
        Directory.CreateDirectory(backupFolderPath);
        Console.WriteLine("Backup directory created or already exists.");

        // Get subdirectories in the base folder path
        var userFolders = Directory.GetDirectories(baseFolderPath);
        Console.WriteLine(string.Format("Found {0} user directories.", userFolders.Length));

        foreach (var userFolder in userFolders)
        {
            string targetFolder = userFolder + subFolderPath; // Construct the target path correctly
            Console.WriteLine(string.Format("Checking for folder in: {0}", targetFolder));

            if (Directory.Exists(targetFolder))
            {
                string current_date = DateTime.Now.ToString("ddMMyyyy");
                string output = Path.Combine(backupFolderPath, new DirectoryInfo(userFolder).Name + "_LBS_" + current_date + ".zip");
                Console.WriteLine(string.Format("Target folder exists. Creating backup for: {0}", targetFolder));

                // Create zip archive
                using (FileStream zipToOpen = new FileStream(output, FileMode.Create))
                {
                    using (ZipArchive archive = new ZipArchive(zipToOpen, ZipArchiveMode.Create))
                    {
                        AddDirectoryToZipArchive(archive, targetFolder, "");
                    }
                }

                Console.WriteLine(string.Format("Backup created at: {0}", output));
            }
            else
            {
                Console.WriteLine(string.Format("Target folder does not exist: {0}", targetFolder));
            }
        }

        Console.WriteLine("Press any key to exit...");
        Console.ReadKey();
    }

    static void AddDirectoryToZipArchive(ZipArchive archive, string directoryPath, string entryName)
    {
        foreach (string file in Directory.GetFiles(directoryPath, "*", SearchOption.AllDirectories))
        {
            string relativePath = entryName + file.Substring(directoryPath.Length).TrimStart('\\');
            Console.WriteLine(string.Format("Adding file to archive: {0} as {1}", file, relativePath));
            ZipArchiveEntry entry = archive.CreateEntry(relativePath);

            using (FileStream fileStream = new FileStream(file, FileMode.Open, FileAccess.Read))
            {
                using (Stream entryStream = entry.Open())
                {
                    fileStream.CopyTo(entryStream);
                }
            }
        }
    }
}
