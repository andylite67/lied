for file in *.sng; do
	iconv -f iso- -t utf-8 "$file" -o "${file}"
done
