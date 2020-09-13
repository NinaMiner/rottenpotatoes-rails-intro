class Movie < ActiveRecord::Base
    #usingthe active record refused to work
 #has_many :movies, ->{order "title"}
 #has_many :movies, ->{order "release_date"}
 #build a class to define particular ratings 
 def self.ratings
    Movie.select(:rating).distinct.inject([]){|a, m| a.push m.rating}
 end
end
