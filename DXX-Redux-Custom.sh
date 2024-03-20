#Original Retropie port installation script
#https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/ports/dxx-rebirth.sh
# /home/admin/RetroPie-Setup/scriptmodules/ports/dxx-rebirth.sh

#Setup the build directory so we can avoid constant references

md_build="$HOME/Descent/dxx-redux"
ports_root="$HOME/RetroPie/roms/ports"
ports_config_root="/opt/retropie/configs/ports"
ports_roms_root="$HOME/RetroPie/roms/ports"

# Clone the source
cd ~
mkdir Descent
cd Descent
git clone https://github.com/dxx-redux/dxx-redux
cd dxx-redux

#Setup Dependencies
sudo apt install build-essential git cmake libphysfs-dev libsdl1.2-dev libsdl-mixer1.2-dev libpng-dev libglew-dev

#Setup cmake
cd d1
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo

#Create RetroPie Ports Installation of DXX-Rebirth
dest_d1="$ports_root/descent1"
dest_d2="$ports_root/descent2"
mkdir "$dest_d1"
mkdir "$dest_d2"

#Copy compiled binaries to final destinations
cp "$md_build/build/d1x-rebirth/d1x-rebirth" "$dest_d1/"
cp "$md_build/build/d2x-rebirth/d2x-rebirth" "$dest_d2/"

# Copy files from build to destination folders in ports
#D1
cp "$md_build/d1x-rebirth/INSTALL.txt" "$dest_d1/D1X-INSTALL.txt"
cp "$md_build/d1x-rebirth/RELEASE-NOTES.txt" "$dest_d1/D1X-RELEASE-NOTES.txt"
cp "$md_build/d1x-rebirth/d1x.ini" "$dest_d1/"
cp "$md_build/COPYING.txt" "$dest_d1/"
cp "$md_build/GPL-3.txt" "$dest_d1/"
cp "$md_build/d1x-rebirth/README.RPi" "$dest_d1/"
cp "$md_build/d1x-rebirth/d1x.ini" "$dest_d1/"

#D2
cp "$md_build/d2x-rebirth/INSTALL.txt" "$dest_d2/D2X-INSTALL.txt"
cp "$md_build/d2x-rebirth/RELEASE-NOTES.txt" "$dest_d2/D2X-RELEASE-NOTES.txt"
cp "$md_build/d2x-rebirth/d2x.ini" "$dest_d2/"
cp "$md_build/COPYING.txt" "$dest_d2/"
cp "$md_build/GPL-3.txt" "$dest_d2/"
cp "$md_build/d2x-rebirth/README.RPi" "$dest_d2/"
cp "$md_build/d2x-rebirth/d2x.ini" "$dest_d2/"

# Make the d1x-rebirth folder structures
mkdir "$dest_d1/data"
mkdir "$dest_d1/demos"
mkdir "$dest_d1/missions"
mkdir "$dest_d1/players"
mkdir "$dest_d1/screenshots"
mkdir "$dest_d1/soundtracks"

# Make the d2x-rebirth folder structures
mkdir "$dest_d2/data"
mkdir "$dest_d2/demos"
mkdir "$dest_d2/missions"
mkdir "$dest_d2/players"
mkdir "$dest_d2/screenshots"
mkdir "$dest_d2/soundtracks"
mkdir "$dest_d2/jukebox"
mkdir "$dest_d2/music"

# Download the shareware files
D1X_SHARE_URL_HOG='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent/shareware/descent.hog'
D1X_SHARE_URL_PIG='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent/shareware/descent.pig'

D2X_SHARE_URL_HAM='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent2/shareware/D2DEMO.HAM'
D2X_SHARE_URL_HOG='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent2/shareware/D2DEMO.HOG'
D2X_SHARE_URL_PIG='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent2/shareware/D2DEMO.PIG'

D1X_HIGH_TEXTURE_URL='https://github.com/JeodC/PortMaster-Descent/blob/main/addons/descent/other/d1xr-hires.dxa'
D1X_OGG_URL='https://github.com/pudlez/dxx-addons/releases/download/v1.0/d1xr-sc55-music.dxa'
D2X_OGG_URL='https://github.com/pudlez/dxx-addons/releases/download/v1.0/d2xr-sc55-music.dxa'

# Download / unpack / install Descent shareware files
if [[ ! -f "$dest_d1/data/descent.hog" ]]; then
    wget -P "$dest_d1/data/" "$D1X_SHARE_URL_HOG" 
fi

if [[ ! -f "$dest_d1/data/descent.pig" ]]; then
    wget -P "$dest_d1/data/" "$D1X_SHARE_URL_PIG"
fi

# High Res Texture Pack
if [[ ! -f "$dest_d1/d1xr-hires.dxa" ]]; then
    wget -P "$dest_d1" "$D1X_HIGH_TEXTURE_URL"
fi

# Ogg Sound Replacement (Roland Sound Canvas SC-55 MIDI)
if [[ ! -f "$dest_d1/d1xr-sc55-music.dxa" ]]; then
    wget -P "$dest_d1" "$D1X_OGG_URL"
fi

# Download / unpack / install Descent 2 shareware files
if [[ ! -f "$dest_d2/data/D2DEMO.HAM" ]]; then
    wget -P "$dest_d2/data/" "$D2X_SHARE_URL_HAM"
fi
if [[ ! -f "$dest_d2/data/D2DEMO.HOG" ]]; then
    wget -P "$dest_d2/data/" "$D2X_SHARE_URL_HOG"
fi
if [[ ! -f "$dest_d2/data/D2DEMO.PIG" ]]; then
    wget -P "$dest_d2/data/" "$D2X_SHARE_URL_PIG"
fi

# Ogg Sound Replacement (Roland Sound Canvas SC-55 MIDI)
if [[ ! -f "$dest_d2/d2xr-sc55-music.dxa" ]]; then
    wget -P "$dest_d2" "$D2X_OGG_URL"
fi

#Fix ownerships
chown -R $user:$user "$dest_d1" "$dest_d2"

# Execute
# $dest_d1/d1x-rebirth

#Backup the original settings file
cp $dest_d1/d1x.ini $dest_d1/d1x-default.ini

# Set the Hog directory to the /data directory
sed "/;-hogdir <s>/a\-hogdir \"$dest_d1/data\"" $dest_d1/d1x-default.ini > $dest_d1/d1x.ini

$dest_d1/d1x-rebirth