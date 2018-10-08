class VisitsMailer < ApplicationMailer
  include ApplicationHelper
  helper ApplicationHelper
  def new_visit(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Visita solicitada')
  end

  def notice_admin_new_visit(visit, user_email)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: user_email, :from => @from, subject: '(VISITAS) Solicitud de visita')
  end

  def notice_assistant_new_visit(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.department.assistant_email, :from => @from, subject: '(VISITAS) Solicitud de visita')
  end

  def visit_approved(visit)
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Solicitud aprobada')
  end
end