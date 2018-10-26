#coding:utf-8
desc "Manda un email al técnico para confirmar la visita al laboratorio"
task :confirm_room_visits => :environment do
  today = Date.today
  # Se verifican las visitas a laboratorio con estatus de agendada y que la visita está confirmada o finalizada y que ya pasaron
  room_visits =  RoomVisit.joins(:visit).where('visits.date < ? AND visits.status IN(?)', Date.today,[Visit::CONFIRMED, Visit::FINISHED]).where(status: RoomVisit::SCHEDULED)
  room_visits.each do |room_visit|
    if room_visit.persona.cuenta_cimav
      VisitsMailer.room_visit_confirm(room_visit).deliver_later
      puts "[CONFIRMAR VISITA] Se notificará a #{room_visit.persona.nombre} sobre visita de #{room_visit.visit.institution}"
    end
  end

end

