class ApplicationController < ActionController::Base
require "rubygems"
require "mechanize"

def sync
  text = ""
  url_main = 'https://pyme.defontana.com/sistema/main.asp'
  url_login = 'https://pyme.defontana.com/sistema/login.asp'
  url_toolbar = 'https://pyme.defontana.com/sistema/toolbar.asp '
  url_main_loged = 'https://pyme.defontana.com/sistema/Matprod/IniMain.asp'
  url_inventario = 'https://pyme.defontana.com/sistema/inven/LisArticulos.ASP?WCI=wiLisArticulos&WCE=form1&WCU'
  @agent = Mechanize.new
  @agent.user_agent_alias= 'Windows IE 6'

  begin
    page = @agent.get(url_main)
    form = page.frame_with(:name => 'main').click.iframe.click.form
    form.txtCliente = 'sonosur'
    form.txtUsuario = 'ddf'
    form.txtPassword = 'dilmanddf'
    @agent.submit(form, form.button)

    page = @agent.get(url_main_loged)
    page = @agent.post(url_inventario)
    page = page.links[0].click
    form = page.form
    page = @agent.submit(form, form.button_with(:name => 'I1'))
    # Para cambiar de página se debe enviar un POST con los parámetros que aparecen debajo.
    # La paginación mostrada corresponde a i+1.
    # Por ejemplo, para ver la página 4, i=3
    # TODO => Iterar sobre 'i' para leer el contenido de los productos.
    page_number = page.search('/html/body/form/table[7]/tr/td[1]').text.to_s.last.to_i

    for i in 0..(page_number - 1)
      page = @agent.post(url_inventario,{"DirPag" => "1","NumPag" => i.to_s,"hidUsaCodBarGS1128" => "N","pagSgte" => "Siguiente >>"})
      # Acá se deben leer los productos, tomar su ID y ejecutar método para actualizar datos que se encuentra en el modelo Product
      logger.debug { "i => #{i}" }
      logger.debug { "#{page.search('/html/body/form/table[7]/tr/td[4]')}" }
      logger.debug { "#{page.content}\n\n\n\n" }
      
    end

    # Y tenemos la página donde se muestran TODOS los productos! YEAH!
    @text = "#{@text}\n\n TABLA_PRODUCTOS =>#{page.content}"

  rescue Mechanize::ResponseReadError => e
    Rails.logger.debug "ERROR => #{e.inspect}"
  end
end
  protect_from_forgery
end
