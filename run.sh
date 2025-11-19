#! bin/bash
#shebang
#précise que le script est exécuté en bash

# 1. Format de la date et chemin du script
ISO_DATE=$(date +%Y-%m-%dT%H:%M:%S.%3N%z)
echo "> Bash script starting at: $ISO_DATE"
# +%Y-%m-%dT%H:%M:%S.%3N%z : format pour avoir la date ISO 8601
# On stocke le résultat dans la variable ISO_DATE
# (sources : labex.io)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "> Script full path: '$SCRIPT_DIR/run.sh'"
# $0 : le nom du script 
# dirname "$0" : récupère le dossier contenant le script
# cd "$(dirname "$0")" && pwd → change de dossier puis récupère le chemin complet absolu
# On stocke ce chemin dans SCRIPT_DIR pour pouvoir créer d’autres dossiers relatifs au script
# (sources : saturncloud.io)

#####################################################################################################
# 2. Créer dossier temporaire
TMP_DIR="$SCRIPT_DIR/tmp"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
# TMP_DIR : dossier temporaire
# rm -rf : supprime l'ancien contenu
# mkdir -p : crée le dossier
# (sources : https://linuxcommandlibrary.com/)

#####################################################################################################
# 3. Téléchargement des JSON + headers
while IFS= read -r url; do
    [ -z "$url" ] && continue
    # ignore les lignes vides

    echo -e "> Downloading '\033[4;34m$url\033[0m'…"
    # affiche l'URL en bleu et souligné

    filename=$(basename "$url")
    curl -s -D "$TMP_DIR/$filename.headers" -o "$TMP_DIR/$filename" "$url"
    # -s : silencieux
    # -D : sauvegarde les headers dans un fichier
    # -o : sauvegarde le contenu JSON

    echo -e "  \033[0;32mDone\033[0m"
    # affiche "Done" en vert
done < "urls.txt"
# lit le fichier urls.txt ligne par ligne

#####################################################################################################
# 4. Copier JSON vers dossier downloads
echo "> Copying JSON files from 'tmp' to 'downloads'…"

rm -rf "downloads"
mkdir -p "downloads"
# supprime et recrée le dossier downloads

cp "$TMP_DIR"/*.json "downloads"/
# copie tous les fichiers JSON du dossier temporaire vers downloads

echo -e "  \033[0;32mDone\033[0m"
# affiche "Done" en vert

#####################################################################################################
# 5. Compiler les headers dans headers.txt
echo "> Compiling HTTP response headers from 'tmp' to 'downloads'…"

HEADERS_FILE="downloads/headers.txt"
> "$HEADERS_FILE"
# crée un fichier vide ou efface l'ancien

for header in "$TMP_DIR"/*.headers; do
    hname=$(basename "$header")
    echo "### $hname:" >> "$HEADERS_FILE"
    cat "$header" >> "$HEADERS_FILE"
    echo "" >> "$HEADERS_FILE"
    # ajoute le contenu des headers avec un séparateur
done

echo -e "  \033[0;32mDone\033[0m"
# affiche "Done" en vert

#####################################################################################################
# 6. Compression en archive
echo "> Compressing all files in 'downloads' to 'archives'…"

mkdir -p "archives"
# crée le dossier archives s'il n'existe pas

ARCHIVE_NAME="D$(date +%Y-%m-%dT%H-%M-%S).tar.gz"
ARCHIVE_PATH="archives/$ARCHIVE_NAME"
# nom dynamique basé sur la date et l'heure

tar -czf "$ARCHIVE_PATH" "downloads"
# crée l'archive compressée gzip de downloads

echo -e "  \033[0;32mDone (archive file name: $ARCHIVE_NAME)\033[0m"
# affiche "Done" et le nom de l'archive en vert

#####################################################################################################
# 7. Fin du script
END_DATE=$(date +%Y-%m-%dT%H:%M:%S.%3N%z)
echo "> Bash script ending at: $END_DATE"
# affiche la date de fin du script

echo "Bye!"

# Lancement du script : bash run.sh
