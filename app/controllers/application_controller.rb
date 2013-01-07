class ApplicationController < ActionController::Base
require "rubygems"
require "mechanize"

def sync
  agent = Mechanize.new
  begin
    page = agent.get('https://pyme.defontana.com/sistema/main.asp')
    Rails.logger.debug "PAGE => #{page.content()}"
    form = page.frame_with(:name => 'main').content().iframe.content().form
    Rails.logger.debug "FORM => #{form}"
    # Se llena formulario
    form.txtCliente = 'sonosur'
    form.txtUsuario = 'ddf'
    form.txtPassword = 'dilmanddf'
    Rails.logger.debug "FORM_MODIFICADO => #{form}"
    # Submit de formulario
    page = agent.submit(form, form.buttons.first)
    # page = agent.get('https://pyme.defontana.com/sistema/inven/LisArticulos.ASP?WCI=wiEditar&WCE=inven@')
    Rails.logger.debug "PAGINA INVENTARIO => #{page.content}"
    redirect_to "http://google.cl"
  rescue Mechanize::ResponseReadError => e
    Rails.logger.debug "ERROR => #{e.inspect}"
  end
end

  protect_from_forgery
end
