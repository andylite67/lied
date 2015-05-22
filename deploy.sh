sh compile.sh
rsync -avhI songs_with_chords/ songs/
ruby tools/gen_database.rb
compass compile static
