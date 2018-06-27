class VisitsMailer < ApplicationMailer
  def new_visit(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Instrucciones para visitas guiadas')
  end
end