sh compile.sh
ruby gen_database.rb
rsync -avhI songs_with_chords songs
compass compile static