#/bin/sh

# Prompt user for project name and dir name
echo ""
echo "Enter the name of the project without spaces (default is MyApp): "
read app_name
if [ -z "$app_name" ]; then
    app_name="MyApp"
fi
echo "Project: $app_name"
echo ""
echo "Enter the name of the project directory (default is $app_name): "
read dir_name
if [ -z "$dir_name" ]; then
    dir_name="$app_name"
fi
echo "Directory: $dir_name"
echo ""



# Set the script directory as current directory
cd $(dirname $0)
# Clone the repository
git clone https://github.com/electron/electron-quick-start
# Rename the folder
mv electron-quick-start $dir_name
# Go into the repository
cd $dir_name
# Clean the repo
rm -Rf .git
rm .gitignore

# Modify the project name into package.json
perl -pi -e "s/\"name\": \"electron-quick-start\"/\"name\": \"$app_name\"/g" package.json
# Add packaging scripts to package.json
perl -pi -e 's/"start": "electron \."/"start": "electron \.",\n\t "pack:osx"  : "electron-packager \. $npm_package_productName --out=dist --platform=darwin --arch=x64 --overwrite",\n\t "pack:mas"  : "electron-packager \. $npm_package_productName --out=dist --platform=mas --arch=x64 --overwrite",\n\t "pack:win32": "electron-packager \. $npm_package_productName --out=dist --platform=win32 --arch=ia32 --overwrite",\n\t "pack:win64": "electron-packager \. $npm_package_productName --out=dist --platform=win32 --arch=x64 --overwrite",\n\t "pack:lin32": "electron-packager \. $npm_package_productName --out=dist --platform=linux --arch=ia32 --overwrite",\n\t "pack:lin64": "electron-packager \. $npm_package_productName --out=dist --platform=linux --arch=x64 --overwrite",\n\t "pack:all"  : "electron-packager \. --all --out=dist --overwrite"/g' package.json
# Modify the project name into package.json
perl -pi -e "s/  \"scripts\":/  \"esversion\": 6,\n  \"scripts\":/g" package.json






# Add a readme.txt
touch readme.txt
echo -e "List of basic commands" >> readme.txt
echo -e "" >> readme.txt
echo -e "Run the application:" >> readme.txt
echo -e "\t$ npm start" >> readme.txt
echo -e "" >> readme.txt
echo -e "Package the application:" >> readme.txt
echo -e "\t$ npm run pack:xxx" >> readme.txt
echo -e "" >> readme.txt
echo -e "where \"xxx\" must be replaced by:" >> readme.txt
echo -e "\tosx (OS X .app)" >> readme.txt
echo -e "\tmas (OS X Mac App Store)" >> readme.txt
echo -e "\tlin32 (Linux 32 bits)" >> readme.txt
echo -e "\tlin64 (Linux 64 bits)" >> readme.txt
echo -e "\twin32 (Windows 32 bits)" >> readme.txt
echo -e "\twin64 (Windows 64 bits)" >> readme.txt

# Install dependencies
npm install
npm install electron-packager --save-dev

# Start project in Atom
atom . readme.txt
