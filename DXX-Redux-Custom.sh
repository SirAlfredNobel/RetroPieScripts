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

#Setup cmake for D1
cd $md_build/d1
# (see cmake -B build -L for more options)
# cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
#Editor causes build time error (inferno)
#cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DIPV6=ON -DEDITOR=ON -DASM=ON
# IPV6 Build fails with errors:  error: ‘struct sockaddr_in6’ has no member named ‘sin_addr’; did you mean ‘sin6_addr’?
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo

# Build D1 (4 cores on a Raspi5)
cmake --build build -j4

#Setup cmake for D2
cd $md_build/d2
# (see cmake -B build -L for more options)
# cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
#Editor causes build time error (inferno)
#cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DIPV6=ON -DEDITOR=ON -DASM=ON
# IPV6 Build fails with errors:  error: ‘struct sockaddr_in6’ has no member named ‘sin_addr’; did you mean ‘sin6_addr’?
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo

# Build D1 (4 cores on a Raspi5)
cmake --build build -j4

#Create RetroPie Ports Installation of DXX-Rebirth
dest_d1="$ports_root/d1x-redux"
dest_d2="$ports_root/d2x-redux"
mkdir "$dest_d1"
mkdir "$dest_d2"

#Copy compiled binaries to final destinations
cp -rf "$md_build/d1/build/main/d1x-redux" "$dest_d1/"
cp -rf "$md_build/d2/build/main/d2x-redux" "$dest_d2/"

# Copy files from build to destination folders in ports
#D1
cp "$md_build/d1/INSTALL.txt" "$dest_d1/D1X-INSTALL.txt"
cp "$md_build/d1/RELEASE-NOTES.txt" "$dest_d1/D1X-RELEASE-NOTES.txt"
cp "$md_build/d1/d1x-default.ini" "$dest_d1/"
cp "$md_build/COPYING.txt" "$dest_d1/"
cp "$md_build/README.md" "$dest_d1/"
cp "$md_build/d1/README.RPi" "$dest_d1/"
cp "$md_build/d1/INSTALL.txt" "$dest_d1/"

#D2
cp "$md_build/d2/INSTALL.txt" "$dest_d2/D2X-INSTALL.txt"
cp "$md_build/d2/RELEASE-NOTES.txt" "$dest_d2/D2X-RELEASE-NOTES.txt"
cp "$md_build/d2/d2x-default.ini" "$dest_d2/"
cp "$md_build/COPYING.txt" "$dest_d2/"
cp "$md_build/README.md" "$dest_d2/"
cp "$md_build/d2/README.RPi" "$dest_d2/"
cp "$md_build/d2/INSTALL.txt" "$dest_d2/"

# Define the path and then Make the d1x-redux folder structures
d1data="$dest_d1/Data"
d1demos="$dest_d1/Demos"
d1missions="$dest_d1/Missions"
d1players="$dest_d1/Players"
d1screenshots="$dest_d1/Screenshots"
d1soundtracks="$dest_d1/Soundtracks"

mkdir "$d1data"
mkdir "$d1demos"
mkdir "$d1missions"
mkdir "$d1players"
mkdir "$d1screenshots"
mkdir "$d1soundtracks"

# Define the path and then Make the d2x-redux folder structures
d2data="$dest_d2/Data"
d2demos="$dest_d2/Demos"
d2missions="$dest_d2/Missions"
d2players="$dest_d2/Players"
d2screenshots="$dest_d2/Screenshots"
d2soundtracks="$dest_d2/Soundtracks"
d2jukebox="$dest_d2/Jukebox"
d2music="$dest_d2/Music"

mkdir "$d2data"
mkdir "$d2demos"
mkdir "$d2missions"
mkdir "$d2players"
mkdir "$d2screenshots"
mkdir "$d2soundtracks"
mkdir "$d2jukebox"
mkdir "$d2music"

# Download the shareware files
D1X_SHARE_URL_HOG='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent/shareware/descent.hog'
D1X_SHARE_URL_PIG='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent/shareware/descent.pig'

D2X_SHARE_URL_HAM='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent2/shareware/D2DEMO.HAM'
D2X_SHARE_URL_HOG='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent2/shareware/D2DEMO.HOG'
D2X_SHARE_URL_PIG='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent2/shareware/D2DEMO.PIG'

D1X_HIGH_TEXTURE_URL='https://github.com/JeodC/PortMaster-Descent/raw/main/addons/descent/other/d1xr-hires.dxa'
D1X_OGG_URL='https://github.com/pudlez/dxx-addons/releases/download/v1.0/d1xr-sc55-music.dxa'
D2X_OGG_URL='https://github.com/pudlez/dxx-addons/releases/download/v1.0/d2xr-sc55-music.dxa'

# Download / unpack / install Descent shareware files
if [[ ! -f "$d1data/descent.hog" ]]; then
    wget -P "$d1data/" "$D1X_SHARE_URL_HOG" 
fi

if [[ ! -f "$d1data/descent.pig" ]]; then
    wget -P "$d1data/" "$D1X_SHARE_URL_PIG"
fi

# High Res Texture Pack
if [[ ! -f "$dest_d1/d1xr-hires.dxa" ]]; then
    wget -P "$dest_d1" "$D1X_HIGH_TEXTURE_URL"
fi

# Ogg Sound Replacement (Roland Sound Canvas SC-55 MIDI)
if [[ ! -f "$d1soundtracks/d1xr-sc55-music.dxa" ]]; then
    wget -P "$d1soundtracks" "$D1X_OGG_URL"
fi

# Download / unpack / install Descent 2 shareware files
if [[ ! -f "$d2data/D2DEMO.HAM" ]]; then
    wget -P "$d2data/" "$D2X_SHARE_URL_HAM"
fi
if [[ ! -f "$d2data/D2DEMO.HOG" ]]; then
    wget -P "$d2data/" "$D2X_SHARE_URL_HOG"
fi
if [[ ! -f "$d2data/D2DEMO.PIG" ]]; then
    wget -P "$d2data/" "$D2X_SHARE_URL_PIG"
fi

# Ogg Sound Replacement (Roland Sound Canvas SC-55 MIDI)
if [[ ! -f "$d2music/d2xr-sc55-music.dxa" ]]; then
    wget -P "$d2music" "$D2X_OGG_URL"
fi

#Fix ownerships
chown -R $user:$user "$dest_d1" "$dest_d2"


#Copy the original settings file so we can customize
cp $dest_d1/d1x-default.ini $dest_d1/d1x.ini

# Set the Hog directory to the correct Data or data directory
sed -i "/;-hogdir <s>/a\-hogdir $d1data" $dest_d1/d1x.ini

# Configure the use of the players directory
sed -i "/;-use_players_dir/a\-use_players_dir" $dest_d1/d1x.ini

# Enable Debug
sed -i "/;-debug/a\-debug" $dest_d1/d1x.ini

# Enable Verbose
sed -i "/;-verbose/a\-verbose" $dest_d1/d1x.ini

# Enable Debug
sed -i "/;-safelog/a\-safelog" $dest_d1/d1x.ini

# Execute
# $dest_d1/d1x-redux
cd $dest_d1
$dest_d1/d1x-redux