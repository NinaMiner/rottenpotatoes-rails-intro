class Movie < ActiveRecord::Base
    #usingthe active record refused to work
 #has_many :movies, ->{order "title"}
 #has_many :movies, ->{order "release_date"}
 #build a class to define particular ratings 

 def self.all_ratings
     %w(G PG PG-13 R)
 end
end
