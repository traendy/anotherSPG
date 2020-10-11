#!/usr/bin/env bash

# container.html wird in output kopiert.
rm -rf output
mkdir -p output
cp container.html output
cp stylesheet.css output

# Für jedes * .md file in blog, projects, me und home muss ein Menüpunkt erstellt werden
# <a href="#Darkmode">Darkmode</a>

# get all content folders
shopt -s nullglob
array=(*/)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later
echo "${array[@]}"

# remove folder output
value="output/"
length="${#array[@]}"
for i in "${!array[@]}"; do
   if [[ "${array[$i]}" = "${value}" ]]; then
       array=( "${array[@]:0:$i}" "${array[@]:$i+1:$length}" )
   fi
done
echo "${array[@]}"

# get all files from each content folder

for i in "${!array[@]}"; do
  shopt -s nullglob
  files=("${array[$i]}"*)
  shopt -u nullglob  
  echo "${files[@]}"
  
  # convert them to js
  for f in "${!files[@]}"; do 
    echo "${files[$f]}"
    # echo "document.write(\`" > "${files[$f]}.js"
    touch "${files[$f]}.html"
    pandoc "${files[$f]}" -f markdown -t html >>"${files[$f]}.html"
    # echo "\`);" >> "${files[$f]}.js"

    # copy them in output
    mv "${files[$f]}.html" output

    case ${array[$i]} in
      blog*)
        Message="blog"
        # fetches the file title without path and extension
        tmp=$(sed 's/.*\/\(.*\).md.*/\1/' <<< "${files[$f]}")
        # tmp="<a href='#${tmp}'>${tmp}<\/a>"
        tmp="<p id=\"navelement\" onclick=\"updateContent('${tmp}')\">${tmp}<\/p>"
        # replace placeholder blog
        sed -i -e "s/<!-- BLOG_ITEM_PLACEHOLDER -->/${tmp}<!-- BLOG_ITEM_PLACEHOLDER -->/g" output/container.html
        echo "Added BLOG item."
        ;;
      projects*)
        Message="projects"
        # fetches the file title without path and extension
        tmp=$(sed 's/.*\/\(.*\).md.*/\1/' <<< "${files[$f]}")
        # tmp="<a href='#${tmp}'>${tmp}<\/a>"
        tmp="<p id=\"navelement\" onclick=\"updateContent('${tmp}')\">${tmp}<\/p>"
        # replace placeholder projects
        sed -i -e "s/<!-- PROJECTS_ITEM_PLACEHOLDER -->/${tmp}<!-- PROJECTS_ITEM_PLACEHOLDER -->/g" output/container.html
        echo "Added PROJECTS item."
        ;;
      me*)
        Message="me"
        # fetches the file title without path and extension
        tmp=$(sed 's/.*\/\(.*\).md.*/\1/' <<< "${files[$f]}")
        # tmp="<a href='#${tmp}'>${tmp}<\/a>"
        tmp="<p id=\"navelement\" onclick=\"updateContent('${tmp}')\">${tmp}<\/p>"
        # replace placeholder me
        sed -i -e "s/<!-- ME_ITEM_PLACEHOLDER -->/${tmp}<!-- ME_ITEM_PLACEHOLDER -->/g" output/container.html
        echo "Added ME item."
        ;;
      *)
        Message="dunno"
        echo "Dunno what to do..."
        ;;
    esac

  done
done

# move assets to outputfolder
mkdir -p output/images
cp images/* output/images/


cd output
python3 -m http.server

# add their names but index.md to content folder matching placeholder as # <a href="#Darkmode">Darkmode</a>

