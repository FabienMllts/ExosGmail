require 'gmail'
require 'google_drive'
require 'rubygems'


def get_the_email_html(town)

	return "<h1>Bonjour</h1>
					<p>Je m'appelle Fabien, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau.<br> La formation s'appelle The Hacking Project (http://thehackingproject.org/).<br> Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours (par exemple envoyer des mails via ruby), sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.</p>
					<p>Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{town}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées.<br> Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{town} !</p>
					<p><strong>Charles, co-fondateur de The Hacking Project</strong> pourra répondre à toutes vos questions : 06.95.46.60.80</p>"

end


def send_email_to_line(dest, town) # Will send an email to the first line of my spreadsheet ( name and email of the first "Mairie") 

	gmail = Gmail.connect(email, password)

		if gmail.logged_in? then puts "connected" else puts "offline" end
		
		gmail.deliver do
			puts "preparing email for #{town} to #{dest}"
		  to dest
  		subject "Formation : The Hacking Project"
  		html_part do
  			content_type 'text/html; charset=UTF-8'
  			body get_the_email_html(town)  			
  		end
  	end

  puts "sent"
	gmail.logout
end

def go_through_all_the_lines() # a loop to send an email to all the line one by one of my worksheet
	g_session = GoogleDrive::Session.from_config("config.json")
	w_sheet = g_session.spreadsheet_by_key("1M1vJ2XhdkrV2JvmHb5RauwYmHlHWv1k-AbdXTFx7Ti8").worksheets[0]

	(1..w_sheet.num_rows).each do |x| # from the first line, to thelast row of my worksheet do the folowing iteration :

		mail_addresse = w_sheet[x, 2] # Email adress = column 2
		city_name = w_sheet[x, 1]	# Name of the city = column 1
		puts "sending mail to : #{city_name}"
		if mail_addresse.include?("@") then send_email_to_line(mail_addresse, city_name) # We use the fist method above to send the email 
		else puts "#{city_name} has given us no email address" end

	end

end

go_through_all_the_lines
