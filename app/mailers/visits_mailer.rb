class VisitsMailer < ApplicationMailer
  include ApplicationHelper
  helper ApplicationHelper
  def new_visit(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Visita solicitada')
  end

  def visit_approved(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Solicitud aprobada')
  end
end