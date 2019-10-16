require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

def open_links(arg)
  puts "Veuillez patienter, scrapping en cours"
  # On récupère la sortie de get_townhalls_urls dans une variable full_url
	full_url = get_townhall_urls
  emails_array = []
  result = []
  # Boucle ouvrant chaque liens de full_url
  full_url.each do |i|
    # On ouvre chaque lien avec Nokogiri et on va chercher les adresses mails avec xpath
      new_url = Nokogiri::HTML(open(i))
      puts "Processing #{i}"
        emails_array << new_url.xpath('//*[contains(text(), "@")]').text
  end

  $town_names.each_with_index do |k, v| 
    result << {k => (emails_array)[v]}
  end

  puts result.inspect
  return result
end

def get_townhall_urls
  # On récupère l'url à parser
  townhall_url = Nokogiri::HTML(open("https://annuaire-des-mairies.com/95/"))
  url_list = []
  # Chemin ciblant tous les textes contenant "html"
    links_list = townhall_url.xpath('//*[contains(text(), "html")]')
    # Boucle stockant les liens vers les diverses mairies sous le format #{nom_de_la_mairie.html}
		links_list.each do |i|
		  url_list << i.text
		end

		full_url = []
    $town_names = []
    # Boucle créant deux array, l'un avec les noms des maires, l'autre avec les liens complets vers les pages contenant les adresses mail
    url_list.each do |elem|
      $town_names << elem[0..-6].to_sym
      # On ajoute #{nom_de_la_mairie.html} à "http://annuaire-des-mairies.com/95/" pour former les liens complets, stockés dans un array
			full_url << "https://www.annuaire-des-mairies.com/95/#{elem}"
    end
  return full_url
end