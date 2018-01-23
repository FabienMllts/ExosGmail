require 'google_drive'
require 'rubygems'
require 'nokogiri'
require 'open-uri'


def get_all_the_urls_of_val_de_marne

	page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-de-marne.html"))
	cities = ""
	page.css('a.lientxt').each do |town|
		site = "https://annuaire-des-mairies.com" + town['href'][1..-1]
		cities = town.text
		$ws[$i, 1] = cities #$ = instance globale
		$ws[$i, 2] = get_the_email_of_a_townhal_from_its_webpage(site)
		$i += 1
		puts "writting :  #{cities} => #{get_the_email_of_a_townhal_from_its_webpage(site)}"

	end
end



def get_the_email_of_a_townhal_from_its_webpage (adresse)
	page = Nokogiri::HTML(open(adresse))  
	
	return page.css('td.style27 p.Style22 font')[6].text
end

def get_all_data_to_google() # send everything on my spreadsheet

	session = GoogleDrive::Session.from_config("config.json")
	$ws = session.spreadsheet_by_key("1M1vJ2XhdkrV2JvmHb5RauwYmHlHWv1k-AbdXTFx7Ti8").worksheets[0]


	$i = 1 # a spreadsheet start at 1
	get_all_the_urls_of_val_de_marne
	$ws.save
	puts "saved!"

end


get_all_data_to_google()