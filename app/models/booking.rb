class Booking < ActiveRecord::Base
  attr_writer :current_step
  
  belongs_to :user
  belongs_to :conference_number
  
  attr_accessible :user_id, :date, :time_start, :time_finish, :conference_number_id, :note, :conference_number
  
  validates_presence_of :user_id, :date, :time_start, :time_finish
  validates_presence_of :conference_number_id,                            :if => :last_step?, :on => :save

  audited
  
  before_validation :update_time
  
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
    self.current_step = steps[steps.index(current_step)-1] unless first_step?
  end

  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
  def check_availability
    ConferenceNumber.find_by_sql(
      ["SELECT id, conference_number 
        FROM conference_numbers 
        WHERE id NOT IN 
          (SELECT conference_numbers.id 
            FROM conference_numbers 
            INNER JOIN bookings 
            ON conference_numbers.id=bookings.conference_number_id 
            WHERE (bookings.time_start BETWEEN ? AND ?) 
            OR (bookings.time_finish BETWEEN ? AND ?)
          )",       
      self.time_start , 
      self.time_finish - 1.second, 
      self.time_start + 1.second, 
      self.time_finish])
  end
  
  def reschedule_availability
    # NOTE: This method is much better than check_availability above. It retrieves the actual objects instead of just the queried parameters.
    # It also reduces the written SQL portion of the query and effectively starts with 'NOT IN' portion.
    # Finally, it uses name placers such as ':start' and ':current_booking_id' instead of the ambigeous question marks '?'.
    
    # FIXME: Re-write 'check_availability' method with the pointers contained in the comments of this section.
    ConferenceNumber.where(  
                              ["id NOT IN 
                                (
                                  SELECT conference_numbers.id 
                                  FROM conference_numbers 
                                  INNER JOIN bookings 
                                  ON conference_numbers.id=bookings.conference_number_id 
                                  WHERE 
                                  (
                                    bookings.id <> :current_booking_id 
                                    AND
                                    (
                                      (bookings.time_start BETWEEN :start AND :almost_finished) 
                                      OR (bookings.time_finish BETWEEN :just_started AND :finish)
                                    )
                                  )
                                )",
                                {
                                  :current_booking_id => self.id,
                                  :start              => self.time_start, 
                                  :almost_finished    => self.time_finish - 1.second, 
                                  :just_started       => self.time_start + 1.second, 
                                  :finish             => self.time_finish
                                }
                              ]
                          )
  end
  
  def update_time
    self.time_start  = Time.parse("#{date} #{time_start.strftime('%H:%M %p')}") if self.time_start.present?
    self.time_finish = Time.parse("#{date} #{time_finish.strftime('%H:%M %p')}") if self.time_finish.present?
  end
  
end # End of the model
