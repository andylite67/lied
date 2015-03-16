FILES=$(find ./ -type f -name *.txt)
for file in $FILES; do
	iconv -f ISO_8859-15 -t utf-8 "$file" -o "${file}"
done
