class Movie < ActiveRecord::Base
    #usingthe active record refused to work
 #has_many :movies, ->{order "title"}
 #has_many :movies, ->{order "release_date"}
 
 def self.ratings
    pluck('DISTINCT rating').sort!
 end
end
