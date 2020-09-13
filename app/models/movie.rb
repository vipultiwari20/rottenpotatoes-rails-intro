class Movie < ActiveRecord::Base
    def self.get_ratings
        temp = Array.new
        self.select('rating').each {|rat| temp.push(rat.rating)}
        temp.sort.uniq
    end
end
