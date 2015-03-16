sh compile.sh
ruby gen_database.rb
rsync -avh songs_with_chords songs
compass compile static