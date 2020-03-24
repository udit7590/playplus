# -------------------- @properties     --------------------
# string      :name
# text        :description
# string      :instructions
# string      :prerequisites
# string      :inclusions
# string      :tags
# references  :category, index: true
# string      :main_image_hashed_id
# -------------------- @properties_end --------------------

class Course < ActiveRecord::Base
  # -------------------------------------------------------------------------------------------------------------------
  # SECTION: FULLTEXT SEARCH
  # -------------------------------------------------------------------------------------------------------------------
  include PgSearch
  pg_search_scope :search_everything, against: [:name, :description, :tags],
                  associated_against: { course_providers: [:city, :state, :country], category: [:name] },
                  using: { tsearch: { dictionary: 'english', any_word: true, prefix: true } }

  # -------------------------------------------------------------------------------------------------------------------
  # SECTION: GEMS , ASSOCIATIONS AND VIRTUAL ATTRIBUTES
  # -------------------------------------------------------------------------------------------------------------------
  attr_accessor :new_main_image
  acts_as_taggable

  has_many :course_providers, dependent: :destroy
  belongs_to :category
  accepts_nested_attributes_for :course_providers, allow_destroy: true

  # -------------------------------------------------------------------------------------------------------------------
  # SECTION: VALIDATIONS
  # -------------------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :description

  before_validation :verify_signature_and_extract_details, if: :main_image_hashed_id

  # -------------------------------------------------------------------------------------------------------------------
  # SECTION: SCOPES
  # -------------------------------------------------------------------------------------------------------------------
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }

  # ******************** TODO_IMP: Prevent delete if it has active enrollments ********************

  # -------------------------------------------------------------------------------------------------------------------
  # SECTION: INSTANCE METHODS
  # -------------------------------------------------------------------------------------------------------------------
  def course_providers_list
    # TODO: Make sure course_providers are not huge. Very unlikely though
    course_providers.active.map do |cp|
      ["#{ cp.locality } - #{ cp.city } - #{ cp.state }", cp.id]
    end
  end

  def category_name
    category.name
  end

  private

    def verify_signature_and_extract_details
      if Cloudinary::PreloadedFile::PRELOADED_CLOUDINARY_PATH =~ main_image_hashed_id
        preloaded = Cloudinary::PreloadedFile.new(main_image_hashed_id)
        if preloaded.valid?
          self.main_image_hashed_id    = preloaded.public_id
        else
          errors[:main_image_hashed_id] << 'has invalid upload signature'
        end
      end
    end
end
