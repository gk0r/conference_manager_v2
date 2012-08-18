## Functions
# 1. Send a booking confirmation email
# 2. Send a booking cancellation email for bookings cancelled by administrators or for bookings cancelled by cascaded effect when the
#    conference number is deleted

class BookingObserver < ActiveRecord::Observer
  
  def after_commit (record)
    Email.booking_created(record.audits.last.user_id, record).deliver
  end

  # Notify all administrators when a new conference number is deleted.
  def after_destroy (record)
    # Only send an email for future cancellations
    Email.booking_deleted(record, record.audits.last.user_id).deliver if record.date.future?
  end
  
end

