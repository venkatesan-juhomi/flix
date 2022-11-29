class Movie < ApplicationRecord

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be an PNG or JPG image'  
  }
  validates :rating, inclusion: { in: RATINGS, message: "%{value} is not  valid" }
  has_many :reviews, dependent: :destroy
  # validate :custom_validation

  # def custom_validation
  #   if self.reviews.stars == 3
  #     errors.add("Stars should not be 3.")
  #   end
  # end

  def flop?
    avg = reviews.average(:stars)
    reviews_count = reviews.size
    if avg && (avg >= 4) && (reviews_count > 50)
      false 
    elsif total_gross > 225000000
      false
    else
      true
    end
  end

  def self.released
    where('released_on < ?', Time.now)
  end

  def self.all_hit_movies
    where('total_gross > ?', 300000000)
  end

  def self.all_flop_movies
    where('total_gross < ?', 225000000)
  end

  def self.recently_added
    where('released_on < ?', Time.now).order('released_on desc').limit(3)
  end

  def average_stars
    average = reviews.average(:stars)
  end

  # def reviews_count
  #   count = reviews.size
  # end

end
