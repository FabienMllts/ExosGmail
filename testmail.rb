require 'gmail'

gmail = Gmail.connect("jeanmidata@gmail.com", "Thehackingproject")
puts gmail.logged_in? 
email = gmail.compose do
	to "jeanmicheltonpote@gmail.com"
	subject "TEST"
	body "YO LES POTES"
end
email.deliver!