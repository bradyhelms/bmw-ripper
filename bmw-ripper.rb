require 'net/http'
require 'uri'


$base_url = "https://www.bagpipetunes.intertechnics.com/"

def main
  # Create a Tunes dir if it doesn't exist already
  puts "Creating directory ./tunes"
  system 'mkdir', '-p', 'tunes'
  puts

  ('A'..'Z').each do |letter|
    puts "Working on #{letter}..."

    letter_uri = gen_uri(letter)
    html = get_page(letter_uri)
    tune_list = parse_html(html)

    # Remove duplicates
    # and any tune names that have an escaped single apostrophe
    tune_list.uniq!.reject! {|tune| tune=~/\\'/}
    tune_list.reject! {|tune| tune=~/ /}

    begin
      (0...tune_list.length).each do |i|
        # Find index of final slash in the tune url
        a = tune_list[i].enum_for(:scan, /\//).map {Regexp.last_match.begin(0)}
         
        # Get substring of tune URL that corresponds to the tune name
        tune_name = tune_list[i][a[-1]+1..-1]
        
        # Create a new file, write the bww info to it
        f = File.new("./tunes/#{tune_name}", "w")
        f.write(get_page($base_url + tune_list[i]))
        f.close
      end
    rescue
      next
    end
  end
end

def get_page(page_uri)
  uri = URI.parse(page_uri)
  response = Net::HTTP.get_response(uri)
  return response.body
end

def gen_uri(letter)
  "https://www.bagpipetunes.intertechnics.com/alpha_results.php?d=" + letter
end

def parse_html(html)
  # Lookahead magic
  re_tune_name = /files(?:(?!files).)*?\.b[mw]w/mi
  html.scan(re_tune_name)
end


def prompt
  print "$> "
  choice = gets.chomp!
  case choice
  when /y/
    main
  when /n/
    exit
  else 
    puts "Please select either 'y' or 'n'"
    prompt
  end
end

puts "---------------------------------------------------"
puts "Warning! This will take some time. (1000s of files)"
puts "Are you sure you want to continue? [y/n]"

prompt
