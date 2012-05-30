class Booking < ActiveRecord::Base
  attr_writer :current_step, :paint
  
  belongs_to :user
  belongs_to :conference_number
  
  attr_accessible :user_id, :date, :time_start, :time_finish, :conference_number_id, :note, :conference_number # FIXME: Remove the last item later.
  
  # validates_presence_of :user_id, :date, :time_start, :time_finish,                         :if => lambda { |b| b.current_step == "one"}
  # validates_presence_of :conference_number_id, :user_id, :date, :time_start, :time_finish,  :if => lambda { |b| b.current_step == "two"}

  validates_presence_of :user_id, :date, :time_start, :time_finish,                         :if => :firsts_step?
  validates_presence_of :conference_number_id, :user_id, :date, :time_start, :time_finish,  :if => :last_step?, :on => :save
  
  def parse?(current_user_id)
    # FIXME: For some reason the times below get stored with an extra 10 hours (UTC offset). Workout why this happens and fix it.
    self.time_start = Time.parse("#{self.date} #{self.time_start.to_s}") unless self.time_start.blank? # time_start # FIXME: Do I need the 'unless' conditions? It seems to work fine without it?
    self.time_finish = Time.parse("#{self.date} #{self.time_finish}") unless self.time_finish.blank? # time_finish
    self.user_id = current_user_id
    
    # Validate
    if self.date && self.time_start && self.time_finish && self.user_id
      true
    else
      false
    end

  end
  
  def steps
    %w[one two]
  end
  
  def current_step
    @current_step || steps.first
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1] unless last_step?
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def firsts_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
  def paint
    return @paint ? true : false
  end
  
end # End of the model