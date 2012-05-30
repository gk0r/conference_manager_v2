class Booking < ActiveRecord::Base
  #include ActiveRecord::StateMachine
  
  belongs_to :user
  belongs_to :conference_number
  
  attr_accessible :user_id, :date, :time_start, :time_finish, :conference_number_id, :note
  
  # validates_presence_of :user_id, :date, :time_start, :time_finish, :if => lambda { |b| b.current_step == "capture_date_time"}
  # validates_presence_of :conference_number_id, :user_id, :date, :time_start, :time_finish, :if => lambda { |b| b.current_step == "check_availability"}
  
  state_machine :state, :initial => :one, :use_transactions => false, :action=>nil do

    event :next_step do
      transition :to => :two
    end
    
    state :one do
      validates_presence_of :user_id
    end
    
    state :two do
      validates_presence_of :date
    end
    
  end
  
  def log
    puts '..Transition.!.'
  end
end

  