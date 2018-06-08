module VisitsHelper
  def status_color(status)
    color = ''
    case status
    when Visit::REQUESTED
      color = 'orange-text text-lighten-2'
    when Visit::APPROVED
      color = 'blue-text text-lighten-2'
    when Visit::CONFIRMED
      color = 'green-text'
    when Visit::CANCELED
      color = 'red-text'
    when Visit::FINISHED
      color = 'purple-text'
    end
  end
end
