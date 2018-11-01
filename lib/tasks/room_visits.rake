#coding:utf-8
desc "Manda un email al técnico para confirmar la visita al laboratorio"
task :confirm_room_visits => :environment do
  today = Date.today
  # Se verifican las visitas a laboratorio con estatus de agendada y que la visita está confirmada o finalizada y que ya pasaron
  room_visits = RoomVisit.joins(:visit).where('visits.date < ? AND visits.status IN(?)', Date.today, [Visit::CONFIRMED, Visit::FINISHED]).where(status: RoomVisit::SCHEDULED)
  room_visits.each do |room_visit|
    if room_visit.persona.cuenta_cimav
      VisitsMailer.room_visit_confirm(room_visit).deliver_later
      puts "[CONFIRMAR VISITA] Se notificará a #{room_visit.persona.nombre} sobre visita de #{room_visit.visit.institution} (id: #{visit.id})"
    end
  end
end


desc "Manda un email a la institución, para recordar que deben confirmar la visita"
task :reminder_confirm_visit => :environment do
  today = Date.today
  # Se verifican las visitas que la fecha está entre 5 y 2 días antes de la fecha del día de hoy
  visits = Visit.where('status = ? AND date BETWEEN ? AND ?', Visit::APPROVED, today + 3.days, today + 5.days)
  visits.each do |visit|
    VisitsMailer.visit_reminder_confirm(visit).deliver_later
    puts "[RECORDAR CONFIRMAR VISITA] Se recordará a #{visit.resp_name} confirmar visita de #{visit.institution} (id: #{visit.id})"
  end
end

desc "Cancela las visitas con estatus de aprobada que no hayan sido confirmadas a tiempo"
task :cancel_unconfirmed_visits => :environment do
  today = Date.today
  # Se verifican las visitas que la fecha igual o menor a dos días del día de hoy
  visits = Visit.where('status = ? AND date < ?', Visit::APPROVED, today + 3.days)
  visits.each do |visit|
    if visit.update(status: Visit::CANCELED)
      puts "[VISITA CANCELADA] Al no haber confirmación, se cancela visita de #{visit.institution} (id: #{visit.id})"
    end
  end
end

desc "Recuerda al asistente dar seguimiento a solicitudes pendientes"
task :reminder_pending_requests => :environment do
  # Se Obtienen todas las solicitudes pendientes y
  User.where(user_type: User::ASSISTANT).each do |assistant|
    pending_requests = Visit.where(status: Visit::REQUESTED).where(department_id: assistant.departments).size
    if pending_requests > 0
      VisitsMailer.reminder_pending_requests(pending_requests, assistant.email).deliver_later
      puts "[RECORDAR SOLICITUDES] Se recordará a #{assistant.name} sobre #{pending_requests} solicitudes pendientes en sus departamentos"
    end
  end
end