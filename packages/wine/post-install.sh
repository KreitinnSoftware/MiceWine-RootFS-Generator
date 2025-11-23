# Get Wine Gecko and Mono Versions
MONO_VERSION=$(grep -R "#define MONO_VERSION" "../dlls/appwiz.cpl/addons.c" | cut -d " " -f 3)
MONO_VERSION=${MONO_VERSION:1:-1}

GECKO_VERSION=$(grep -R "#define GECKO_VERSION" "../dlls/appwiz.cpl/addons.c" | cut -d " " -f 3)
GECKO_VERSION=${GECKO_VERSION:1:-1}

# Download Wine Gecko and Mono and Package Together with Wine
curl -LO# "https://dl.winehq.org/wine/wine-mono/$MONO_VERSION/wine-mono-$MONO_VERSION-x86.tar.xz"
curl -LO# "https://dl.winehq.org/wine/wine-gecko/$GECKO_VERSION/wine-gecko-$GECKO_VERSION-x86_64.tar.xz"
curl -LO# "https://dl.winehq.org/wine/wine-gecko/$GECKO_VERSION/wine-gecko-$GECKO_VERSION-x86.tar.xz"

mkdir -p ../destdir-pkg/$PREFIX
mkdir -p ../destdir-pkg/$PREFIX/../wine/share/{mono,gecko}

tar -xf "wine-mono-$MONO_VERSION-x86.tar.xz" -C ../destdir-pkg/$PREFIX/../wine/share/wine/mono
tar -xf "wine-gecko-$GECKO_VERSION-x86.tar.xz" -C ../destdir-pkg/$PREFIX/../wine/share/wine/gecko
tar -xf "wine-gecko-$GECKO_VERSION-x86_64.tar.xz" -C ../destdir-pkg/$PREFIX/../wine/share/wine/gecko

rm -rf ../destdir-pkg/$PREFIX

rm -f "wine-mono-$MONO_VERSION-x86.tar.xz" "wine-gecko-$GECKO_VERSION-x86.tar.xz" "wine-gecko-$GECKO_VERSION-x86_64.tar.xz"
