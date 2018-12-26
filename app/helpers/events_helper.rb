module EventsHelper

  def format_event_date(event)
    if event.start_date != event.end_date
      event.start_date.strftime("%d/%m/%Y")  + " - " + event.end_date.strftime("%d/%m/%Y")
    else
      event.start_date.strftime("%d/%m/%Y")
    end
  end

end
