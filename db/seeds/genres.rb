genres = %w(Action Adventure Comedy Drama Horror Romance ScienceFiction Fantasy Historical Crime)
genres.each do |genre|
  Genre.find_or_create_by(name: genre)
end