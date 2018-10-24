class VisitsMailer < ApplicationMailer
  include ApplicationHelper
  helper ApplicationHelper

  def new_visit(visit)
    # email para notificar a la institución que se recibió su solicitud, además de que suban los documentos
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Visita solicitada')
  end

  def new_visit_admin(visit, user_email)
    # email para notificar al administrador que se recibió una solicitud
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: user_email, :from => @from, subject: '(VISITAS) Solicitud de visita')
  end

  def new_visit_assistant(visit, user_email)
    # email para notificar al asistente que se recibió una solicitud
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: user_email, :from => @from, subject: '(VISITAS) Solicitud de visita')
  end

  def visit_pre_approved(visit, user_email)
    # email para notificar al administrador que se pre-aprobó una visita
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: user_email, :from => @from, subject: '(VISITAS) Solicitud pre-aprobada')
  end

  def visit_approved(visit)
    # email para notificar a la institución que se aprobó la visita
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Solicitud aprobada')
  end

  def visit_confirmed(visit)
    # email para notificar a la institución que se confirmó la visita
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: @visit.resp_email, :from => @from, subject: '(VISITAS) Visita confirmada')
  end

  def visit_confirmed_admin(visit, user_email)
    # email para notificar al administrador y asistente que se confirmó una visita
    @visit = visit
    @from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
    mail(to: user_email, :from => @from, subject: '(VISITAS) Visita confirmada')
  end

end