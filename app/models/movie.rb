class Movie < ApplicationRecord

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS, message: "%{value} is not  valid" }
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
  has_one_attached :movie_title_image
  validate :acceptable_image

  scope :released, lambda {where("released_on < ?", Time.now)}
  scope :upcoming, lambda {where("released_on > ?", Time.now)}
  scope :recent, lambda {where("released_on > ? AND released_on < ?", Time.now - 7.days, Time.now).order("released_on desc")}
  scope :flop?, lambda {where('total_gross < ?', 225000000)}
  before_save :set_slug

  def set_slug
    self.slug = title.parameterize
  end

  def to_param
    title.parameterize
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def like_count
    likes.count
  end

  def reviewd?(user)
    reviews.exists?(user: user)
  end

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

  private

  def acceptable_image
    return unless movie_title_image.attached?
    if movie_title_image.byte_size >= 1.megabyte
      errors.add(:movie_title_image, "size should not exceed 1MB.")
    end
    acceptable_types = ["image/png", "image/jpg", "image/jpeg"]
    unless acceptable_types.include? movie_title_image.content_type
      errors.add(:movie_title_image, "must be a jpeg or png format.")
    end
  end

end
