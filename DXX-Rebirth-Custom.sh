#Original Retropie port installation script
#https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/ports/dxx-rebirth.sh
# /home/admin/RetroPie-Setup/scriptmodules/ports/dxx-rebirth.sh

#Setup the build directory so we can avoid constant references
md_build="$HOME/Descent/dxx-rebirth"
ports_root="$HOME/RetroPie/roms/ports"
ports_config_root="/opt/retropie/configs/ports"
ports_roms_root="$HOME/RetroPie/roms/ports"

# Clone the source
cd ~
mkdir Descent
cd Descent
git clone https://github.com/dxx-rebirth/dxx-rebirth
cd dxx-rebirth

#Setup Dependencies
sudo apt install build-essential scons libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libphysfs-dev libstdc++6

#Check GCC Version
gcc --version

# Correct an error caused by an error when linking against lib64
# d1x-rebirth: /lib/aarch64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.31' not found
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

#On a Rpi5 Only
if cat /proc/cpuinfo | grep -q 'Raspberry Pi 5'; then
    CFLAGS='-march=armv8.2-a+crypto+fp16+rcpc+dotprod -mcpu=cortex-a76+crypto -mtune=cortex-a76 -mfix-cortex-a53-835769 -mfix-cortex-a53-843419' CXXFLAGS="${CFLAGS}"
fi
# Turn off the excessive gcc preprocessor warnings:
CPPFLAGS='-Wp,-w'

#Setup scons with correct flags WORKING?!?
if cat /proc/cpuinfo | grep -q 'Raspberry Pi 5'; then
    sudo scons -Q -j 4 raspberrypi=mesa opengl=yes opengles=no sdl2=yes ipv6=yes words_need_alignment=yes CXXFLAGS="${CXXFLAGS}" CPPFLAGS="${CPPFLAGS}"
else
    ECHO "FAILED to see it as a pi 5"
    # sudo scons raspberrypi=mesa opengl=yes opengles=no sdl2=yes ipv6=yes words_need_alignment=yes CXXFLAGS="${CXXFLAGS}" CPPFLAGS="${CPPFLAGS}" 
fi


#Create RetroPie Ports Installation of DXX-Rebirth
dest_d1="$ports_root/d1x-rebirth"
dest_d2="$ports_root/d2x-rebirth"
mkdir "$dest_d1"
mkdir "$dest_d2"

#Copy compiled binaries to final destinations
# Configure with BIN_DIR ?
cp -rf "$md_build/build/d1x-rebirth/d1x-rebirth" "$dest_d1/"
cp -rf "$md_build/build/d2x-rebirth/d2x-rebirth" "$dest_d2/"

# Copy files from build to destination folders in ports
#D1
cp "$md_build/d1x-rebirth/INSTALL.txt" "$dest_d1/D1X-INSTALL.txt"
cp "$md_build/d1x-rebirth/RELEASE-NOTES.txt" "$dest_d1/D1X-RELEASE-NOTES.txt"
cp "$md_build/d1x-rebirth/d1x.ini" "$dest_d1/"
cp "$md_build/COPYING.txt" "$dest_d1/"
cp "$md_build/GPL-3.txt" "$dest_d1/"
cp "$md_build/d1x-rebirth/README.RPi" "$dest_d1/"
cp "$md_build/d1x-rebirth/d1x.ini" "$dest_d1/"
cp "$md_build/d1x-rebirth/d1x-rebirth.png" "$dest_d1/"
cp "$md_build/d1x-rebirth/d1x-rebirth.xpm" "$dest_d1/"

#D2
cp "$md_build/d2x-rebirth/INSTALL.txt" "$dest_d2/D2X-INSTALL.txt"
cp "$md_build/d2x-rebirth/RELEASE-NOTES.txt" "$dest_d2/D2X-RELEASE-NOTES.txt"
cp "$md_build/d2x-rebirth/d2x.ini" "$dest_d2/"
cp "$md_build/COPYING.txt" "$dest_d2/"
cp "$md_build/GPL-3.txt" "$dest_d2/"
cp "$md_build/d2x-rebirth/README.RPi" "$dest_d2/"
cp "$md_build/d2x-rebirth/d2x.ini" "$dest_d2/"
cp "$md_build/d2x-rebirth/d2x-rebirth.png" "$dest_d2/"
cp "$md_build/d2x-rebirth/d2x-rebirth.xpm" "$dest_d2/"

# Define the path and then Make the d1x-redux folder structures
d1data="$dest_d1/data"
d1demos="$dest_d1/demos"
d1missions="$dest_d1/missions"
d1players="$dest_d1/players"
d1screenshots="$dest_d1/screenshots"
d1soundtracks="$dest_d1/soundtracks"

mkdir "$d1data"
mkdir "$d1demos"
mkdir "$d1missions"
mkdir "$d1players"
mkdir "$d1screenshots"
mkdir "$d1soundtracks"

# Define the path and then Make the d2x-redux folder structures
d2data="$dest_d2/data"
d2demos="$dest_d2/demos"
d2missions="$dest_d2/missions"
d2players="$dest_d2/players"
d2screenshots="$dest_d2/screenshots"
d2soundtracks="$dest_d2/soundtracks"
d2jukebox="$dest_d2/jukebox"
d2music="$dest_d2/music"

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
if [[ ! -f "$d1data/d1xr-hires.dxa" ]]; then
    wget -P "$d1data/" "$D1X_HIGH_TEXTURE_URL"
fi

# Ogg Sound Replacement (Roland Sound Canvas SC-55 MIDI)
if [[ ! -f "$d1data/d1xr-sc55-music.dxa" ]]; then
    wget -P "$d1data/" "$D1X_OGG_URL"
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
if [[ ! -f "$d2data/d2xr-sc55-music.dxa" ]]; then
    wget -P "$d2data/" "$D2X_OGG_URL"
fi

#Fix ownerships
chown -R $user:$user "$dest_d1" "$dest_d2"

# Configure D1x-Rebirth Settings

#Backup the original settings file
cp $dest_d1/d1x.ini $dest_d1/d1x-default.ini

# Set the Hog directory to the /data directory
sed -i "/;-hogdir <s>/a\-hogdir $d1data" $dest_d1/d1x.ini


# Configure the use of the players directory
sed -i "/;-use_players_dir/a\-use_players_dir" $dest_d1/d1x.ini

# Enable Debug
#sed -i "/;-debug/a\-debug" $dest_d1/d1x.ini

# Enable Verbose
#sed -i "/;-verbose/a\-verbose" $dest_d1/d1x.ini

# Enable Safelog
#sed -i "/;-safelog/a\-safelog" $dest_d1/d1x.ini

# Configure D2x-Rebirth Settings

#Backup the original settings file
cp $dest_d2/d2x.ini $dest_d2/d2x-default.ini

# Set the Hog directory to the /data directory
sed -i "/;-hogdir <s>/a\-hogdir $d2data" $dest_d2/d2x.ini


# Configure the use of the players directory
sed -i "/;-use_players_dir/a\-use_players_dir" $dest_d2/d2x.ini

# Enable Debug
#sed -i "/;-debug/a\-debug" $dest_d1/d1x.ini

# Enable Verbose
#sed -i "/;-verbose/a\-verbose" $dest_d1/d1x.ini

# Enable Safelog
#sed -i "/;-safelog/a\-safelog" $dest_d1/d1x.ini



# Execute D1
# $dest_d1/d1x-rebirth
# cd $dest_d1
# $dest_d1/d1x-rebirth

# Execute D2
# $dest_d2/d2x-rebirth
# cd $dest_d2
# $dest_d2/d2x-rebirth
