# 1. Vérification des arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <url_file> <download_dir> <archive_dir>"
    exit 1
fi
#if ... then ... fi : c’est la structure conditionnelle en bash.
#Ça veut dire : "Si la condition est vraie, alors exécute ce qui est à l’intérieur
# -ne : différent de. 
# "Si l’utilisateur n’a pas mis exactement 3 arguments, 
#alors on explique comment utiliser le script et on arrête tout.

URL_FILE="$1"
DOWNLOAD_DIR="$2"
ARCHIVES_DIR="$3"
#arguments stockés dans des variables pour facilier la réutilisation

####################################################################################################

# 2. Format de la date et chemin du script
ISO_DATE=$(date +%Y-%m-%dT%H:%M:%S.%3N%z)
echo "> Bash script starting at: $ISO_DATE"
# +%Y-%m-%dT%H:%M:%S.%3N%z : format pour avoir la date ISO 8601
# On stocke le résultat dans la variable ISO_DATE
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "> Script full path: '$SCRIPT_DIR/run.sh'"
# $0 → le nom du script 
#dirname "$0" : récupère le dossier contenant le script
#cd "$(dirname "$0")" && pwd → change de dossier puis récupère le chemin complet absolu
#On stocke ce chemin dans la variable SCRIPT_DIR pour pouvoir créer d’autres dossiers relatifs au script
# Affiche le chemin complet vers le script
#(sources : labex.io)

#####################################################################################################

# 3. Créer dossier temporaire
TMP_DIR="$SCRIPT_DIR/tmp"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
#On définit une variable TMP_DIR qui va contenir le chemin du dossier temporaire.
#supprime des fichiers ou dossiers. nettoie le dossier temporaire avant de commencer
# mkdir : crée un dossier.

######################################################################################################

# 4. Téléchargement des JSON + headers
while IFS= read -r url; do
    [ -z "$url" ] && continue

    echo -e "> Downloading '\033[4;34m$url\033[0m'…"

    filename=$(basename "$url")
    curl -s -D "$TMP_DIR/$filename.headers" -o "$TMP_DIR/$filename" "$url"

    echo -e "  \033[0;32mDone\033[0m"
done < "$URL_FILE"
#while … do … done : boucle
#< "$URL_FILE": redirige le contenu du fichier urls.txt dans la boucle.
#read -r url: lit une ligne du fichier à la fois et la stocke dans la variable url.
#IFS=: ignore les espaces en début ou fin de ligne 

#######################################################################################################

# 5. Copier JSON vers dossier downloads
echo "> Copying JSON files from 'tmp' to '$DOWNLOAD_DIR'…"

rm -rf "$DOWNLOAD_DIR" #supprime le dossier
mkdir -p "$DOWNLOAD_DIR" #recréer le dossier s'il existait

cp "$TMP_DIR"/*.json "$DOWNLOAD_DIR"/ #cp = copier : tous les fichiers avec l'extension json dans le dossier download

echo -e "  \033[0;32mDone\033[0m"
# affiche "Done" en vert

#########################################################################################################

# 6. Compiler les headers dans headers.txt
echo "> Compiling HTTP response headers from 'tmp' to '$DOWNLOAD_DIR'…"
# On dit à l'utilisateur qu'on va rassembler tous les headers dans un fichier

HEADERS_FILE="$DOWNLOAD_DIR/headers.txt"
> "$HEADERS_FILE"
# On crée le fichier headers.txt vide (ou on efface ce qu'il y avait avant)

for header in "$TMP_DIR"/*.headers; do
    hname=$(basename "$header")
    echo "### $hname:" >> "$HEADERS_FILE"
    cat "$header" >> "$HEADERS_FILE"
    echo "" >> "$HEADERS_FILE"
done
# for … do … done : on fait la même action pour chaque fichier .headers dans tmp
# basename prend juste le nom du fichier, sans le chemin
# echo "### $hname:" >> … : on écrit le nom du fichier dans headers.txt
# cat "$header" >> … : on copie le contenu du fichier dans headers.txt
# echo "" >> … : on met une ligne vide pour séparer les headers des différents fichiers

echo -e "  \033[0;32mDone\033[0m"
# On affiche "Done" en vert

#########################################################################################################

# 7. Compression en archive
echo "> Compressing all files in '$DOWNLOAD_DIR' to '$ARCHIVES_DIR'…"
# On dit à l'utilisateur qu'on va compresser tous les fichiers de downloads dans archives

mkdir -p "$ARCHIVES_DIR"
# On crée le dossier archives s'il n'existe pas déjà

ARCHIVE_NAME="D$(date +%Y-%m-%dT%H-%M-%S).tar.gz"
ARCHIVE_PATH="$ARCHIVES_DIR/$ARCHIVE_NAME"
# On crée le nom de l'archive avec la date et l'heure pour que ce soit unique

tar -czf "$ARCHIVE_PATH" "$DOWNLOAD_DIR"
# tar -czf : on fait une archive compressée en gzip
# "$ARCHIVE_PATH" : le nom et chemin de l'archive à créer
# "$DOWNLOAD_DIR" : le dossier à compresser

echo -e "  \033[0;32mDone (archive file name: $ARCHIVE_NAME)\033[0m"
# On affiche "Done" en vert

#########################################################################################################

# 8. Fin du script
END_DATE=$(date +%Y-%m-%dT%H:%M:%S.%3N%z)
# On prend la date et l'heure actuelles pour dire quand le script se termine

echo "> Bash script ending at: $END_DATE"
# On affiche à l'écran que le script se termine maintenant avec la date et l'heure

echo "Bye!"

# lancement du script : bash run.sh urls.txt downloads archives

