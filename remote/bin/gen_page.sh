#!/bin/bash
#$1: work dir
#$2: md parser script
#$3: md parser
#$4: html dir
#$5: page list generator
#$6: bin dir
#$7: number of entries on first page
#$8: blog titel
#$9: blog subtitle
#$10: h1 marker
#$11: footer links
#$12: link spacer

#parse md and create html
echo "Writeing html files"
find $1 -type f -name "*\.md" -execdir $2 $3 '{}' $4 \;

#delete old files
echo "Writeing file list to"
rm -rf "$1/tmpFileList"
rm -rf "$1/sortedFileList"
rm -rf "$4/*"

#generate file list
##create sorted list of entries
find $1 -type f -name "*\.md" -execdir $5 $1 '{}' $1 $6 \;

##post process list
sort -r "$1/tmpFileList" > "$1/sortedFileList"
#head -n $7 "$1/sortedFileList" > "$1/tmpFileList"
cat "$1/tmpFileList" > "$1/sortedFileList"
sed 's/\.md/\.html/g' "$1/sortedFileList" > "$1/tmpFileList"
head -n $7 "$1/tmpFileList" > "$1/shortSortedFileList"
cp "$1/tmpFileList" "$1/sortedFileList"

#create index.html
sed "s/BLOGTITLE/$8/g" "$1/templates/page_head" > "$1/tmpHead"

##insert index head
cat "$1/tmpHead" >> "$4/index.html"
sed "s/BLOGTITLE_MAIN/$8/g" "$1/templates/index_head" > "$1/tmpHead2"
sed "s/BLOGTITLE_SUB/$9/g" "$1/tmpHead2" > "$1/tmpHead3"
cat "$1/tmpHead3" >> "$4/index.html"

##write index
while read line
do
    file=$line
    echo "<div class="hentry"><article>" >> "$4/index.html"
    postDate=`echo -n "$file" | awk -F ";" '{print $1}'`
    abbrDate=`echo -n $postDate | sed 's/-//g'`
    abbrDate=`echo -n $abbrDate | sed 's/ /T/g'`
    author=`echo -n "$file" | awk -F ";" '{print $3}'`
    author=`echo $author | sed 's/\s/\ /g'`
    author=`echo $author | sed 's/,/<\/span><\/span>, <span class=\"author vcard\"><span class=\"fn\">/g'`
    echo -n $file | awk -v path=$4 -F ";" '{printf(path"/"$2)}' | xargs cat > "$1/tmpIndex"
    sed "s/<h1>/<h1 class=\"entry-title\">/g" "$1/tmpIndex" > "$1/tmpIndex2"
    sed "1,/<p>/s/<p>/<p class=\"entry-summary\">/" "$1/tmpIndex2" > "$1/tmpIndex"
    sed "s/<\/h1>/\&nbsp;<abbr class=\"updated published\" title=\"$abbrDate\"><time>($postDate)<\/time><\/abbr><\/h1>/g" "$1/tmpIndex" >> "$4/index.html"

    echo "&nbsp;<author>(<span class=\"author vcard\"><span class=\"fn\">$author</span></span>)</author></article></div>" >> "$4/index.html"
done < "$1/shortSortedFileList"

##insert index footer
echo "<hr>" >> "$4/index.html"

echo -n "${11}" | awk -v space=${12} -F ";" '{if (NF > 0) {print "<div id=\"footerLinks\">"}; for (i = 1; i <= NF; i++) { split($i,array,","); printf("<a href=\"%s\">%s</a>", array[2], array[1]); if (i < NF) {printf space}}; if (NF > 0) {printf "</div>"}}' >> "$4/index.html"

cat "$1/templates/index_footer" >> "$4/index.html"
cat "$1/templates/page_footer" >> "$4/index.html"

sed "s/<h1>/<h1>${10}/g" "$4/index.html" > "$1/replace_tmp"
cat "$1/replace_tmp" > "$4/index.html"

##write overview
##insert overview head
cat "$1/tmpHead" >> "$4/overview.html"
sed "s/BLOGTITLE_MAIN/$8/g" "$1/templates/overview_head" > "$1/tmpHead2"
cat "$1/tmpHead2" >> "$4/overview.html"

##write overview page
while read line
do
    file=$line
    echo "<div class="hentry"><article>" >> "$4/overview.html"
    postDate=`echo -n "$file" | awk -F ";" '{print $1}'`
    author=`echo -n "$file" | awk -F ";" '{print $3}'`
    author=`echo $author | sed 's/\s/\ /g'`
    echo -n $file | awk -v path=$4 -F ";" '{printf(path"/"$2)}' | xargs cat > "$1/tmpIndex"
    sed "s/<\/h1>/\&nbsp;<time>($postDate)<\/time><\/h1>/g" "$1/tmpIndex" >> "$4/overview.html"

    echo "&nbsp;<author>($author)</author></article></div>" >> "$4/overview.html"
done < "$1/sortedFileList"

##insert overview footer
echo "<hr>" >> "$4/overview.html"
cat "$1/templates/overview_footer" >> "$4/overview.html"
cat "$1/templates/page_footer" >> "$4/overview.html"

sed "s/<h1>/<h1>${10}/g" "$4/overview.html" > "$1/replace_tmp"
cat "$1/replace_tmp" > "$4/overview.html"

#move css
echo "Copy CSV"
cp "$1/templates/style.css" "$4/style.css"

#move images
echo "Copy images"
mkdir "$4/img"
cp -r "$1/img/" "$4/img"

#move docs
echo "Copy docs"
mkdir "$4/doc"
cp -r "$1/doc/" "$4/doc"

