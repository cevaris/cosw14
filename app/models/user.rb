class User < ActiveRecord::Base
  TYPES = {:photographer =>'Photographer', :attendee=>'Attendee', :coordinator=>'Event Coordinator'}#, :admin =>'Admin' }
  PHONE_FORMAT = /\A[0-9]{10}\z/


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # attr_accessor :password, :password_confirmation, :current_password, :encrypted_password, :phone_number

  has_many :events

  has_attached_file :avatar, 
    :default_url => "/assets/default.png",
    styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
    }

  # Validate the attached image is image/jpg, image/png, etc
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
  validates_format_of :phone_number, with: PHONE_FORMAT, message: "has an invalid format."


  before_save :default_values
  def default_values
    # self.slug ||= SecureRandom.hex[0..10]
    self.slug ||= loop do
      token = SecureRandom.hex[0..3]
      break token unless User.exists?(slug: token)
    end
  end

  def to_param
    self.slug
  end 


end
